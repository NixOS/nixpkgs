# shellcheck shell=bash
set -e

export PATH="@binPath@:$PATH"

LOCKFILE_OUTPUT="$1"

genericBuild

nuget-to-json "${NUGET_PACKAGES%/}" >"$LOCKFILE_OUTPUT"

echo "Successfully wrote lockfile to $LOCKFILE_OUTPUT"
