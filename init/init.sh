#! @bash@/bin/sh -e

export PATH=@bash@/bin:@coreutils@/bin:@findutils@/bin

echo "--- Nix ---"

#echo "remounting root..."

echo "starting root shell..."

@bash@/bin/sh

echo "shutting down..."
exit 0
