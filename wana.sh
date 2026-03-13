#!/usr/bin/env bash

#deklarace proměnných
FILTER_AFTER=""
FILTER_BEFORE=""
FILTER_IP=""
FILTER_URI=""
COMMAND=""

# cyklus while pro parsování jednotlivých argumentů z logů
while [ "$#" -gt 0 ]; do
    case "$1" in
            -a)   FILTER_AFTER="$2"
                    shift 2
                    ;;
            -b)   FILTER_BEFORE="$2"
                    shift 2
                    ;;
            -ip)  FILTER_IP="$2"
                    shift 2
                    ;;
            -uri) FILTER_URI="$2"
                    shift 2
                    ;;
            list-ip | list-hosts | ...)   COMMAND="$1"
                    shift
                    ;;
            -*)   echo "Neznámý přepínač $1" >&2; exit 1 ;;
            *)    break ;;   # zbytek jsou soubory
    esac
done

get_input() {
    if [ "$#" -eq 0 ]; then
        cat        # čte stdin
    else
        for file in "$@"; do
            case "$file" in
                *.gz) gzip -cd "$file" ;;
                *)    cat "$file" ;;
            esac
        done
    fi
}


get_input "$@" | awk -v filter_ip="$FILTER_IP" '
{
    if (filter_ip != "" && $1 != filter_ip) next
    print
}
'