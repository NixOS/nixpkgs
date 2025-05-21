
# lib/deprecated

Do not add any new functions to this directory.

This directory contains the `lib.misc` sublibrary, which - as a location - is deprecated.
Furthermore, some of the functions inside are of *dubious* utility, and should perhaps be avoided,
while some functions *may still be needed*.

This directory does not play a role in the deprecation process for library functions.
They should be deprecated in place, by putting a `lib.warn` or `lib.warnIf` call around the function.
