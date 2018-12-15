#! @shell@ -e

# skip this if there are no modems at all
if ! stat -t "@spoolAreaPath@"/etc/config.* >/dev/null 2>&1
then
  exit 0
fi

echo "faxq started, waiting for modem(s) to initialize..."

for i in `seq @timeoutSec@0 -1 0`  # gracefully timeout
do
  sleep 0.1
  # done if status files exist, but don't mention initialization
  if \
    stat -t "@spoolAreaPath@"/status/* >/dev/null 2>&1 \
    && \
    ! grep --silent --ignore-case 'initializing server' \
    "@spoolAreaPath@"/status/*
  then
    echo "modem(s) apparently ready"
    exit 0
  fi
  # if i reached 0, modems probably failed to initialize
  if test $i -eq 0
  then
    echo "warning: modem initialization timed out"
  fi
done
