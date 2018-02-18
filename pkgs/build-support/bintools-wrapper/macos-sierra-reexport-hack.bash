#! @shell@

set -eu -o pipefail

path_backup="$PATH"
if [ -n "@coreutils_bin@" ]; then
  PATH="@coreutils_bin@/bin"
fi

source @out@/nix-support/utils.sh

expandResponseParams "$@"

declare -r recurThreshold=300

declare overflowCount=0
for p in "${params+"${params[@]}"}";  do
    case "$p" in
        -l*) let overflowCount+=1 ;;
        -reexport-l*) let overflowCount+=1 ;;
        *) ;;
    esac
done

declare -a allArgs=()

if (( "$overflowCount" <= "$recurThreshold" )); then
    allArgs=("${params+"${params[@]}"}")
else
    declare -a childrenLookup=() childrenLink=()

    for p in "${params+"${params[@]}"}"; do
        case "$p" in
            -L/*)
                childrenLookup+=("$p")
                allArgs+=("$p")
                ;;
            -L)
                echo "cctools LD does not support '-L foo' or '-l foo'" >&2
                exit 1
                ;;
            -l)
                echo "cctools LD does not support '-L foo' or '-l foo'" >&2
                exit 1
                ;;
            -lazy_library | -lazy_framework | -lto_library)
                # We aren't linking any "azy_library", "to_library", etc.
                allArgs+=("$p")
                ;;
            -lazy-l | -weak-l)    allArgs+=("$p") ;;
                # We can't so easily prevent header issues from these.
            -lSystem)             allArgs+=("$p") ;;
                # Special case as indirection seems like a bad idea for something
                # so fundamental. Can be removed for simplicity.
            -l?* | -reexport-l?*) childrenLink+=("$p") ;;
            *)                    allArgs+=("$p") ;;
        esac
    done

    declare n=0
    while (( $n < "${#childrenLink[@]}" )); do
        if [[ "${childrenLink[n]}" = -l* ]]; then
            childrenLink[n]="-reexport${childrenLink[n]}"
        fi
        let ++n
    done
    unset n

    declare -r outputNameLibless=$(basename $( \
        if [[ -z "${outputName:+isUndefined}" ]]; then
            echo unnamed
        elif [[ "${outputName:0:3}" = lib ]]; then
            echo "${outputName:3}"
        else
            echo "${outputName}"
        fi))
    declare -ra children=("$outputNameLibless-reexport-delegate-0" \
                          "$outputNameLibless-reexport-delegate-1")

    mkdir -p "$out/lib"

    PATH="$PATH:@out@/bin"

    symbolBloatObject=$outputNameLibless-symbol-hack.o
    if [[ ! -e $symbolBloatObject ]]; then
        # `-Q` means use GNU Assembler rather than Clang, avoiding an awkward
        # dependency cycle.
        printf '.private_extern _______child_hack_foo\nchild_hack_foo:\n' \
            | @targetPrefix@as -Q -- -o $symbolBloatObject
    fi

    responseFileBoth=$(mktemp)
    printf " %q\n" "${childrenLookup[@]}" >$responseFileBoth
    printf " %q\n" "$symbolBloatObject" >>$responseFileBoth    
    # first half of libs
    responseFile1=$(mktemp)
    printf " %q\n" "${childrenLink[@]:0:$((${#childrenLink[@]} / 2 ))}" >$responseFile1
    @targetPrefix@ld -macosx_version_min $MACOSX_DEPLOYMENT_TARGET -arch x86_64 -dylib \
      -o "$out/lib/lib${children[0]}.dylib" \
      -install_name "$out/lib/lib${children[0]}.dylib" \
      "@$responseFileBoth" "@$responseFile1"

    # second half of libs
    responseFile2=$(mktemp)
    printf " %q\n" "${childrenLink[@]:$((${#childrenLink[@]} / 2 ))}" >$responseFile2
    @targetPrefix@ld -macosx_version_min $MACOSX_DEPLOYMENT_TARGET -arch x86_64 -dylib \
      -o "$out/lib/lib${children[1]}.dylib" \
      -install_name "$out/lib/lib${children[1]}.dylib" \
      "@$responseFileBoth" "@$responseFile2"

    allArgs+=("-L$out/lib" "-l${children[0]}" "-l${children[1]}")
fi

templinks="$(mktemp -d "$PWD/XXXX")"
prefix="$(basename $templinks)/"
function finish {
    rm "$prefix"*
    rmdir "$templinks"
}
trap finish EXIT

declare -i n=0
shorterArgs=()
nParams=${#allArgs[@]}
while (( "$n" < "$nParams" )); do
    p=${allArgs[n]}
    case "$p" in
        -L/*)
            if [ -d "${p:2}" ]; then
                ln -s "${p:2}" "$prefix$n"
                shorterArgs+=("-L$prefix$n")
            fi
            ;;
        *)
            shorterArgs+=("$p") ;;
    esac
    n+=1
done
PATH="$path_backup"
@prog@ "${shorterArgs[@]}"
