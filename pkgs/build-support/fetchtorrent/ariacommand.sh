ariaCommand() {
    # filter status messages of aria to make it less verbose
    # use the output-filter only with a known version of aria
    if $debug || [ "$(aria2c --version | head -n1 )" != "aria2 version 1.36.0" ]; then
        aria2c "$@"
        return $?
    fi

    # create DHT cache file
    # hide false error: Exception caught while loading DHT routing table
    # https://github.com/aria2/aria2/issues/1253
    # based on aria2/src/DHTRoutingTableDeserializer.cc
    if ! [ -e $HOME/.cache/aria2/dht.dat ]; then
        hex=""
        hex+="a1 a2" # 0+2: magic
        hex+="02" # 2+1: format
        hex+="00 00 00" # 3+3
        hex+="00 03" # 6+2: version
        hex+=$(printf "%016x\n" $(date --utc +%s)) # 8+8: time
        hex+="00 00 00 00 00 00 00 00" # 16+8: localnode
        hex+=$(dd if=/dev/random bs=1 count=40 status=none | sha1sum - | cut -c1-40) # 24+20: localnode ID
        hex+="00 00 00 00" # 44+4: reserved
        hex+="00 00 00 00" # 48+4: num_nodes uint32_t
        hex+="00 00 00 00" # 52+4: reserved
        mkdir -p $HOME/.cache/aria2
        echo $hex | xxd -r -p >$HOME/.cache/aria2/dht.dat
    fi

    # need coproc to capture return code of aria
    coproc aria_process { LANG=C LC_ALL=C aria2c "$@"; }
    # aria_process[0] = stdout
    # aria_process[1] = stdin
    # { echo asdf; } >&${aria_process[1]} # write to stdin
    #exec {aria_process[1]}>&- # close stdin

    local line
    local L
    local state=0
    local linebuf=()
    local summary_time=
    local seen_summary=false
    local line_time=
    local line_rest=
    local green_notice=$'\e[1;32mNOTICE\e[0m'
    local red_error=$'\e[1;31mERROR\e[0m'

    # read stdout of aria
    while read -ru ${aria_process[0]} line; do
        #echo "state $state: line: ${line@Q}"

        if [ $state = 0 ]; then
            if [ -z "$line" ]; then
                # ignore empty line
                continue
            fi
            if [[ "$line" = "[#"* ]]; then
                # "[#" line = start of summary?
                #echo "state: $state -> 1"
                state=1
                linebuf+=("$line")
                continue
            elif [[ "$line" = "*** Download Progress Summary"* ]]; then
                # start of summary without previous "[#" lines
                summary_time=$(echo "$line" | cut -d' ' -f7-11)
                summary_time=$(date -d"$summary_time" +"%F %T")
                #echo "state: $state -> 2"
                state=2
                continue
            fi
            if echo "$line" | grep -q -E '^[0-9]{2}/[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} '; then
                # fix time format: 02/19 11:02:00
                line_time=$(date -d"${line:0:14}" +"%F %T")
                line_rest="${line:15}"
                line="$line_time $line_rest"
            fi
            if ! $seen_summary && [[ "$line" = *"[$red_error] Checksum error detected"* ]]; then
                # ignore false checksum error on empty output
                # https://github.com/aria2/aria2/issues/2033
                continue
            fi
            # ignore some status messages
            if [[ "$line" = *"[$green_notice] Download of selected files was complete." ]]; then
                continue
            fi
            if [[ "$line" = *"[$green_notice] Seeding is over." ]]; then
                continue
            fi
            if [[ "$line" = *"[$green_notice] Download complete: "* ]]; then
                continue
            fi
            echo "$line"
            continue
        fi

        # bug in aria: when output to pipe, "[#" lines can appear before summary
        # bug in aria: no empty line before the first summary

        if [ $state = 1 ]; then
            linebuf+=("$line")
            if [[ "$line" = "[#"* ]]; then
                # another "[#" line = start of summary?
                continue
            elif [[ "$line" = "*** Download Progress Summary"* ]]; then
                # start of summary after previous "[#" lines
                summary_time=$(echo "$line" | cut -d' ' -f7-11)
                summary_time=$(date -d"$summary_time" +"%F %T")
                #echo "state: $state -> 2"
                state=2
                continue
            fi
            # no start of summary
            for L in "${linebuf[@]}"; do
                if [ -z "$line" ]; then
                    continue
                fi
                if [[ "$line" = "[#"* ]]; then
                    L="${L:1: -1}" # remove square brackets
                fi
                L="$(date +"%F %T") $L" # # add time prefix
                echo "$L"
            done
            # reset
            #echo "state: $state -> 0"
            state=0
            linebuf=()
            continue
        fi

        if [ $state = 2 ]; then
            linebuf+=("$line")
            if [ -n "$line" ] && [[ "$line" != "-"* ]]; then
                continue
            fi
            # dash line or empty line
            # end of summary
            #printf "summary line: %s\n" "${linebuf[@]}"
            last_progress=$(printf "%s\n" "${linebuf[@]}" | grep '^\[' | tail -n1)
            last_progress="${last_progress:1: -1}" # remove square brackets
            last_progress="${last_progress:8}" # remove collection hash
            echo "$summary_time $last_progress"
            # reset
            #echo "state: $state -> 0"
            state=0
            linebuf=()
            continue
        fi
    done

    if (( ${#linebuf[@]} > 0 )); then
        # print unprocessed lines
        printf "%s\n" "${linebuf[@]}"
    fi

    # get return code of aria
    wait $aria_process_PID
}
