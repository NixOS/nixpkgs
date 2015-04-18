#!/bin/bash

set -e
set -u

# I've also tried adding -z direct and -z lazyload, but it gave too many problems with C++ exceptions :'(
# Also made sure libgcc would not be lazy-loaded, as suggested here: https://www.illumos.org/issues/2534#note-3
#   but still no success.
cmd="@ld@ -z ignore"

args=("$@");

# This loop makes sure all -L arguments are before -l arguments, or ld may complain it cannot find a library.
# GNU binutils does not have this problem:
#   http://stackoverflow.com/questions/5817269/does-the-order-of-l-and-l-options-in-the-gnu-linker-matter
i=0;
while [[ $i -lt $# ]]; do
    case "${args[$i]}" in
        -L)  cmd="$cmd ${args[$i]} ${args[($i+1)]}"; i=($i+1); ;;
        -L*) cmd="$cmd ${args[$i]}" ;;
        *)   ;;
    esac
    i=($i+1);
done

i=0;
while [[ $i -lt $# ]]; do
    case "${args[$i]}" in
        -L)  i=($i+1); ;;
        -L*) ;;
        *)   cmd="$cmd ${args[$i]}" ;;
    esac
    i=($i+1);
done

# Trace:
set -x
exec $cmd

exit 0
