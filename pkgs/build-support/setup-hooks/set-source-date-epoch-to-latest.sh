updateSourceDateEpoch() {
    local path="$1"

    # Get the last modification time of all regular files, sort them, and get the most recent. 
    local time="0"
    local newestFile=""
    local threshold=$(date +%s -r "$NIX_BUILD_TOP/..")
    IFS=$'\n'
    for r in $(find "$path" -type f -printf '%T@ %p\n'); do
      IFS=' '
      local -a res=( $r )
      local t="${res[0]//\.[0-9]*/}" # remove the fraction part
      if [ "$t" -ge "$threshold" ]; then
        echo "ignore generated file ${res[1]}"
      elif [ "$time" -lt "$t" ]; then
        time="$t"
        newestFile="${res[1]}"
      fi
    done
    
    # Update $SOURCE_DATE_EPOCH if the most recent file we found is newer.
    if [ "$time" -gt "$SOURCE_DATE_EPOCH" ]; then
        echo "setting SOURCE_DATE_EPOCH to timestamp $time of file $newestFile"
        export SOURCE_DATE_EPOCH="$time"

        # Warn if the new timestamp is too close to the present. This
        # may indicate that we were being applied to a file generated
        # during the build, or that an unpacker didn't restore
        # timestamps properly.
        local now="$(date +%s)"
        if [ "$time" -gt $((now - 60)) ]; then
            echo "warning: file $newestFile may be generated; SOURCE_DATE_EPOCH may be non-deterministic"
        fi
    fi
}

postUnpackHooks+=(_updateSourceDateEpochFromSourceRoot)

_updateSourceDateEpochFromSourceRoot() {
    if [ -n "$sourceRoot" ]; then
        updateSourceDateEpoch "$sourceRoot"
    fi
}
