#!/usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils gnugrep gnused

################################################################################
# nix-diff.sh                                                                  #
################################################################################
# This script "diffs" Nix profile generations.                                 #
#                                                                              #
# Example:                                                                     #
################################################################################
# > nix-diff.sh 90 92                                                          #
# + gnumake-4.2.1                                                              #
# + gnumake-4.2.1-doc                                                          #
# - htmldoc-1.8.29                                                             #
################################################################################
# The example shows that as of generation 92 and since generation 90,          #
# gnumake-4.2.1 and gnumake-4.2.1-doc have been installed, while               #
# htmldoc-1.8.29 has been removed.                                             #
#                                                                              #
# The example above shows the default, minimal output mode of this script.     #
# For more features, run `nix-diff.sh -h` for usage instructions.              #
################################################################################

usage() {
    cat <<EOF
usage: nix-diff.sh [-h | [-p profile | -s] [-q] [-l] [range]]
-h:         print this message before exiting
-q:         list the derivations installed in the parent generation
-l:         diff every available intermediate generation between parent and
            child
-p profile: specify the Nix profile to use
            * defaults to ~/.nix-profile
-s:         use the system profile
            * equivalent to: -p /nix/var/nix/profiles/system
profile:    * should be something like /nix/var/nix/profiles/default, not a
              generation link like /nix/var/nix/profiles/default-2-link
range:      the range of generations to diff
            * the following patterns are allowed, where A, B, and N are positive
              integers, and G is the currently active generation:
                A..B => diffs from generation A to generation B
                ~N   => diffs from the Nth newest generation (older than G) to G
                A    => diffs from generation A to G
            * defaults to ~1
EOF
}

usage_tip() {
    echo 'run `nix-diff.sh -h` for usage instructions' >&2
    exit 1
}

while getopts :hqlp:s opt; do
    case $opt in
        h)
            usage
            exit
            ;;
        q)
            opt_query=1
            ;;
        l)
            opt_log=1
            ;;
        p)
            opt_profile=$OPTARG
            ;;
        s)
            opt_profile=/nix/var/nix/profiles/system
            ;;
        \?)
            echo "error: invalid option -$OPTARG" >&2
            usage_tip
            ;;
    esac
done
shift $((OPTIND-1))

if [ -n "$opt_profile" ]; then
    if ! [ -L "$opt_profile" ]; then
        echo "error: expecting \`$opt_profile\` to be a symbolic link" >&2
        usage_tip
    fi
else
    opt_profile=$(readlink ~/.nix-profile)
    if (( $? != 0 )); then
        echo 'error: unable to dereference `~/.nix-profile`' >&2
        echo 'specify the profile manually with the `-p` flag' >&2
        usage_tip
    fi
fi

list_gens() {
    nix-env -p "$opt_profile" --list-generations \
        | sed -r 's:^\s*::' \
        | cut -d' ' -f1
}

current_gen() {
    nix-env -p "$opt_profile" --list-generations \
        | grep -E '\(current\)\s*$' \
        | sed -r 's:^\s*::' \
        | cut -d' ' -f1
}

neg_gen() {
    local i=0 from=$1 n=$2 tmp
    for gen in $(list_gens | sort -rn); do
        if ((gen < from)); then
            tmp=$gen
            ((i++))
            ((i == n)) && break
        fi
    done
    if ((i < n)); then
        echo -n "error: there aren't $n generation(s) older than" >&2
        echo " generation $from" >&2
        return 1
    fi
    echo $tmp
}

match() {
    argv=("$@")
    for i in $(seq $(($#-1))); do
        if grep -E "^${argv[$i]}\$" <(echo "$1") >/dev/null; then
            echo $i
            return
        fi
    done
    echo 0
}

case $(match "$1" '' '[0-9]+' '[0-9]+\.\.[0-9]+' '~[0-9]+') in
    1)
        diffTo=$(current_gen)
        diffFrom=$(neg_gen $diffTo 1)
        (($? == 1)) && usage_tip
        ;;
    2)
        diffFrom=$1
        diffTo=$(current_gen)
        ;;
    3)
        diffFrom=${1%%.*}
        diffTo=${1##*.}
        ;;
    4)
        diffTo=$(current_gen)
        diffFrom=$(neg_gen $diffTo ${1#*~})
        (($? == 1)) && usage_tip
        ;;
    0)
        echo 'error: invalid invocation' >&2
        usage_tip
        ;;
esac

dirA="${opt_profile}-${diffFrom}-link"
dirB="${opt_profile}-${diffTo}-link"

declare -a temp_files
temp_length() {
    echo -n ${#temp_files[@]}
}
temp_make() {
    temp_files[$(temp_length)]=$(mktemp)
}
temp_clean() {
    rm -f ${temp_files[@]}
}
temp_name() {
    echo -n "${temp_files[$(($(temp_length)-1))]}"
}
trap 'temp_clean' EXIT

temp_make
versA=$(temp_name)
refs=$(nix-store -q --references "$dirA")
(( $? != 0 )) && exit 1
echo "$refs" \
    | grep -v env-manifest.nix \
    | sort \
          > "$versA"

print_tag() {
    local gen=$1
    nix-env -p "$opt_profile" --list-generations \
        | grep -E "^\s*${gen}" \
        | sed -r 's:^\s*::' \
        | sed -r 's:\s*$::'
}

if [ -n "$opt_query" ]; then
    print_tag $diffFrom
    cat "$versA" \
        | sed -r 's:^[^-]+-(.*)$:    \1:'

    print_line=1
fi

if [ -n "$opt_log" ]; then
    gens=$(for gen in $(list_gens); do
               ((diffFrom < gen && gen < diffTo)) && echo $gen
           done)
    # Force the $diffTo generation to be included in this list, instead of using
    # `gen <= diffTo` in the preceding loop, so we encounter an error upon the
    # event of its nonexistence.
    gens=$(echo "$gens"
           echo $diffTo)
else
    gens=$diffTo
fi

temp_make
add=$(temp_name)
temp_make
rem=$(temp_name)
temp_make
out=$(temp_name)

for gen in $gens; do

    [ -n "$print_line" ] && echo

    temp_make
    versB=$(temp_name)

    dirB="${opt_profile}-${gen}-link"
    refs=$(nix-store -q --references "$dirB")
    (( $? != 0 )) && exit 1
    echo "$refs" \
        | grep -v env-manifest.nix \
        | sort \
              > "$versB"

    in=$(comm -3 -1 "$versA" "$versB")
    sed -r 's:^[^-]*-(.*)$:\1+:' <(echo "$in") \
        | sort -f \
               > "$add"

    un=$(comm -3 -2 "$versA" "$versB")
    sed -r 's:^[^-]*-(.*)$:\1-:' <(echo "$un") \
        | sort -f \
               > "$rem"

    cat "$rem" "$add" \
        | sort -f \
        | sed -r 's:(.*)-$:- \1:' \
        | sed -r 's:(.*)\+$:\+ \1:' \
        | grep -v '^$' \
              > "$out"

    if [ -n "$opt_query" -o -n "$opt_log" ]; then

        lines=$(wc -l "$out" | cut -d' ' -f1)
        tag=$(print_tag "$gen")
        (( $? != 0 )) && exit 1
        if [ $lines -eq 0 ]; then
            echo "$tag   (no change)"
        else
            echo "$tag"
        fi
        cat "$out" \
            | sed 's:^:    :'

        print_line=1

    else
        echo "diffing from generation $diffFrom to $diffTo"
        cat "$out"
    fi

    versA=$versB

done

exit 0
