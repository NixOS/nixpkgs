#!/usr/bin/env bash
set -euo pipefail

if (( $# < 2 )); then
    echo "usage: $0 MPI_DEV MPI_OUT [mpiexec options...]" >&2
    exit 2
fi
mpiDev=$1
mpiOut=$2
shift 2
sourceDir=$(cd "$(dirname "$0")" && pwd)
testDir=$(mktemp -d)
trap 'rm -rf "$testDir"' EXIT

"$mpiDev/bin/mpicc" -std=gnu11 -O2 "$sourceDir/floating-c.c" -o "$testDir/floating-c"
"$mpiDev/bin/mpifort" -O2 "$sourceDir/floating-fortran.f90" -o "$testDir/floating-fortran"

# Continue after either failure so the C controls and Fortran regression both
# produce evidence. Two ranks exercise communication and collective reductions.
status=0
for executable in floating-c floating-fortran; do
    "$mpiOut/bin/mpiexec" "$@" -n "${MPI_TEST_RANKS:-2}" "$testDir/$executable" || status=1
done
exit "$status"
