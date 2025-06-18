#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git -p common-updater-scripts

set -eu -o pipefail

repo="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git"

revision="$(git ls-remote --refs --tags --sort refname "$repo" | tail -n1 | cut -f2 | cut -d '/' -f3)"

update-source-version linux-firmware "$revision"
