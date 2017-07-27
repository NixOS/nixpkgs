#! @shell@

set -eu -o pipefail

path_backup="$PATH"
if [ -n "@coreutils_bin@" ]; then
  PATH="@coreutils_bin@/bin"
fi

declare -r recurThreshold=300

declare overflowCount=0
for ((n=0; n < $#; ++n)); do
    case "${!n}" in
        -l*) let overflowCount+=1 ;;
        -reexport-l*) let overflowCount+=1 ;;
        *) ;;
    esac
done

declare -a allArgs=()

if (( "$overflowCount" <= "$recurThreshold" )); then
    allArgs=("$@")
else
    declare -a childrenLookup=() childrenLink=()

    while (( $# )); do
        case "$1" in
            -L/*)
                childrenLookup+=("$1")
                allArgs+=("$1")
                ;;
            -L)
                echo "cctools LD does not support '-L foo' or '-l foo'" >&2
                exit 1
                ;;
            -l)
                echo "cctools LD does not support '-L foo' or '-l foo'" >&2
                exit 1
                ;;
            -lto_library)  allArgs+=("$1") ;;
                # We aren't linking any "to_library"
            -lSystem)      allArgs+=("$1") ;;
                # Special case as indirection seems like a bad idea for something
                # so fundamental. Can be removed for simplicity.
            -l?*)          childrenLink+=("$1") ;;
            -reexport-l?*) childrenLink+=("$1") ;;
            *)             allArgs+=("$1") ;;
        esac

        shift
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
        printf '.private_extern _______child_hack_foo\nchild_hack_foo:\n' \
            | @binPrefix@as -- -o $symbolBloatObject
    fi

    # first half of libs
    @binPrefix@ld -macosx_version_min 10.10 -arch x86_64 -dylib \
      -o "$out/lib/lib${children[0]}.dylib" \
      -install_name "$out/lib/lib${children[0]}.dylib" \
      "${childrenLookup[@]}" "$symbolBloatObject" \
      "${childrenLink[@]:0:$((${#childrenLink[@]} / 2 ))}"

    # second half of libs
    @binPrefix@ld -macosx_version_min 10.10 -arch x86_64 -dylib \
      -o "$out/lib/lib${children[1]}.dylib" \
      -install_name "$out/lib/lib${children[1]}.dylib" \
      "${childrenLookup[@]}" "$symbolBloatObject" \
      "${childrenLink[@]:$((${#childrenLink[@]} / 2 ))}"

    allArgs+=("-L$out/lib" "-l${children[0]}" "-l${children[1]}")
fi

PATH="$path_backup"
exec @prog@ "${allArgs[@]}"
