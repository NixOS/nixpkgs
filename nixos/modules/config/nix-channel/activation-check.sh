# shellcheck shell=bash

explainChannelWarning=0
if [[ -e "/root/.nix-defexpr/channels" ]]; then
    warn '/root/.nix-defexpr/channels exists, but channels have been disabled.'
    explainChannelWarning=1
fi
if [[ -e "/nix/var/nix/profiles/per-user/root/channels" ]]; then
    warn "/nix/var/nix/profiles/per-user/root/channels exists, but channels have been disabled."
    explainChannelWarning=1
fi
while IFS=: read -r _ _ _ _ _ home _ ; do
    if [[ -n  "$home" && -e "$home/.nix-defexpr/channels" ]]; then
        warn "$home/.nix-defexpr/channels exists, but channels have been disabled." 1>&2
        explainChannelWarning=1
    fi
done < <(getent passwd)
if [[ $explainChannelWarning -eq 1 ]]; then
    echo "Due to https://github.com/NixOS/nix/issues/9574, Nix may still use these channels when NIX_PATH is unset." 1>&2
    echo "Delete the above directory or directories to prevent this." 1>&2
fi
