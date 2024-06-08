#! @shell@
# shellcheck shell=bash

set -eu -o pipefail +o posix
shopt -s nullglob

if (( "${NIX_DEBUG:-0}" >= 7 )); then
    set -x
fi

source @signingUtils@

extraAfter=()
extraBefore=()
params=("$@")

output=
inputs=()

restAreFiles=
prev=
for p in \
    ${extraBefore+"${extraBefore[@]}"} \
    ${params+"${params[@]}"} \
    ${extraAfter+"${extraAfter[@]}"}
do
    if [ "$restAreFiles" ]; then
        inputs+=("$p")
    else
        case "$prev" in
            -s|-R|-d|-arch)
                # Unrelated arguments with values
                ;;
            -o)
                # Explicit output
                output="$p"
                ;;
            *)
                # Any other orgument either takes no value, or is a file.
                if [[ "$p" != -* ]]; then
                    inputs+=("$p")
                fi
                ;;
        esac

        if [ "$p" == - ]; then
            restAreFiles=1
        fi
    fi

    prev="$p"
done

# Optionally print debug info.
if (( "${NIX_DEBUG:-0}" >= 1 )); then
    # Old bash workaround, see above.
    echo "extra flags before to @prog@:" >&2
    printf "  %q\n" ${extraBefore+"${extraBefore[@]}"}  >&2
    echo "original flags to @prog@:" >&2
    printf "  %q\n" ${params+"${params[@]}"} >&2
    echo "extra flags after to @prog@:" >&2
    printf "  %q\n" ${extraAfter+"${extraAfter[@]}"} >&2
fi

@prog@ \
    ${extraBefore+"${extraBefore[@]}"} \
    ${params+"${params[@]}"} \
    ${extraAfter+"${extraAfter[@]}"}

if [ "$output" ]; then
    # Single explicit output
    signIfRequired "$output"
else
    # Multiple inputs, rewritten in place
    for input in "${inputs[@]}"; do
      signIfRequired "$input"
    done
fi
