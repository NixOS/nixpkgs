source $stdenv/setup

set -f
sources_=($sources)
targets_=($targets)
modes_=($modes)
path_=($path)
set +f

mkdir -p $out/$path_

for ((i = 0; i < ${#targets_[@]}; i++)); do
    source="${sources_[$i]}"
    target="${targets_[$i]}"

    if [[ "$source" =~ '*' ]]; then

        # If the source name contains '*', perform globbing.
        mkdir -p $out/$path_/$target
        for fn in $source; do
            ln -s "$fn" $out/$path_/$target/
        done

    else
        
        mkdir -p $out/$path_/$(dirname $target)
        if ! [ -e $out/$path_/$target ]; then
            ln -s $source $out/$path_/$target
        else
            echo "duplicate entry $target -> $source"
            if test "$(readlink $out/$path_/$target)" != "$source"; then
                echo "mismatched duplicate entry $(readlink $out/$path_/$target) <-> $source"
                exit 1
            fi
        fi
       
        if test "${modes_[$i]}" != symlink; then
            echo "${modes_[$i]}" > $out/$path_/$target.mode
        fi
        
    fi
done

