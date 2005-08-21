#! @bash@/bin/sh -e

. @out@/bin/env.sh

tty=$1

exec < $tty > $tty 2>&1

echo
echo "=== Welcome to Nix! ==="

export HOME=/root
cd $HOME

exec @bash@/bin/sh
