# Use the last part of the out path as hash input for the build.
# This should ensure that it is deterministic across rebuilds of the same
# derivation and not easily collide with other builds.
export NIX_CFLAGS_COMPILE+=" -frandom-seed=${out##*/}"
