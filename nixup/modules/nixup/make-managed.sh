source $stdenv/setup

mkdir -p $out/sources
mkdir -p $out/dynamics
mkdir -p $out/volatiles
mkdir -p $out/modes
mkdir -p $out/uids
mkdir -p $out/gids

set -f
targets_=($targets)
sources_=($sources)
dynamics_=($dynamics)
volatiles_=($volatiles)
modes_=($modes)
users_=($users)
groups_=($groups)
set +f

for ((i = 0; i < ${#targets_[@]}; i++)); do
    source="${sources_[$i]}"
    target="${targets_[$i]}"

    if [[ "$source" =~ '*' ]]; then

        # If the source name contains '*', perform globbing.
        mkdir -p $out/sources/$target
        for fn in $source; do
            ln -s "$fn" $out/sources/$target/
        done

    else
        
        mkdir -p $out/sources/$(dirname $target)
        if ! [ -e $out/sources/$target ]; then
            ln -s $source $out/sources/$target
        else
            echo "duplicate entry $target -> $source"
            if test "$(readlink $out/sources/$target)" != "$source"; then
                echo "mismatched duplicate entry $(readlink $out/sources/$target) <-> $source"
                exit 1
            fi
        fi

        if test "${dynamics_[$i]}" == true; then
            mkdir -p $out/dynamics/$(dirname $target)
            touch $out/dynamics/$target
        fi

        if test "${volatiles_[$i]}" == true; then
            mkdir -p $out/volatiles/$(dirname $target)
            touch $out/volatiles/$target
        fi

        if test "${modes_[$i]}" != symlink; then
            mkdir -p $out/modes/$(dirname $target)
            echo "${modes_[$i]}"  > $out/modes/$target
            mkdir -p $out/uids/$(dirname $target)
            echo "${users_[$i]}"  > $out/uids/$target
            mkdir -p $out/gids/$(dirname $target)
            echo "${groups_[$i]}" > $out/gids/$target
        fi
        
    fi
done

