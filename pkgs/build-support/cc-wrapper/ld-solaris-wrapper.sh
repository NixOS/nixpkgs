#!@shell@
set -eu -o pipefail
shopt -s nullglob

declare -a args=("$@")
# I've also tried adding -z direct and -z lazyload, but it gave too many problems with C++ exceptions :'(
# Also made sure libgcc would not be lazy-loaded, as suggested here: https://www.illumos.org/issues/2534#note-3
#   but still no success.
declare -a argsBefore=(-z ignore) argsAfter=()

# This loop makes sure all -L arguments are before -l arguments, or ld may complain it cannot find a library.
# GNU binutils does not have this problem:
#   http://stackoverflow.com/questions/5817269/does-the-order-of-l-and-l-options-in-the-gnu-linker-matter
while (( $# )); do
    case "${args[$i]}" in
        -L)   argsBefore+=("$1" "$2"); shift ;;
        -L?*) argsBefore+=("$1") ;;
        *)    argsAfter+=("$1") ;;
    esac
    shift
done

# Trace:
set -x
exec "@ld@" "${argsBefore[@]}" "${argsAfter[@]}"
