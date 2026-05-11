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

input=

pprev=
prev=
for p in \
    ${extraBefore+"${extraBefore[@]}"} \
    ${params+"${params[@]}"} \
    ${extraAfter+"${extraAfter[@]}"}
do
    if [ "$pprev" != "-change" ] && [[ "$prev" != -* ]] && [[ "$p" != -* ]]; then
        input="$p"
    fi
    pprev="$prev"
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

sign "$input"
