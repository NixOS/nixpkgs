#!@shell@
set -euo pipefail

export dataDir="${dataDir:-@defaultDataDir@}"

exec @out@/lib/pulsarr/start.sh "$@"
