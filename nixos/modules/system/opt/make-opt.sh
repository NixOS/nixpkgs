source $stdenv/setup

mkdir -p $out/opt

set -f
sources_=($sources)
targets_=($targets)
modes_=($modes)
users_=($users)
groups_=($groups)
set +f

for ((i = 0; i < ${#targets_[@]}; i++)); do
    source="${sources_[$i]}"
    target="${targets_[$i]}"

    if [[ "$source" =~ '*' ]]; then

        # If the source name contains '*', perform globbing.
        mkdir -p $out/opt/$target
        for fn in $source; do
            ln -s "$fn" $out/opt/$target/
        done

    else

        mkdir -p $out/opt/$(dirname $target)
        if ! [ -e $out/opt/$target ]; then
            ln -s $source $out/opt/$target
        else
            echo "duplicate entry $target -> $source"
            if test "$(readlink $out/opt/$target)" != "$source"; then
                echo "mismatched duplicate entry $(readlink $out/opt/$target) <-> $source"
                exit 1
            fi
        fi

        if test "${modes_[$i]}" != symlink; then
            echo "${modes_[$i]}"  > $out/opt/$target.mode
            echo "${users_[$i]}"  > $out/opt/$target.uid
            echo "${groups_[$i]}" > $out/opt/$target.gid
        fi

    fi
done
