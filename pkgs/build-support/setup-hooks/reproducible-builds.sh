# shellcheck shell=bash
# Use the last part of the out path as hash input for the build.
# This should ensure that it is deterministic across rebuilds of the same
# derivation and not easily collide with other builds.
# We also truncate the hash so that it cannot cause reference cycles.
NIX_CFLAGS_COMPILE="${NIX_CFLAGS_COMPILE:-} -frandom-seed=$(
    outbase="${out##*/}"
    randomseed="${outbase:0:10}"
    echo $randomseed
)"
export NIX_CFLAGS_COMPILE
