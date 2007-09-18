#! @shell@ -e


# What are we supposed to do?
action="$1"

showSyntax() {
    # !!! more or less cut&paste from
    # system/switch-to-configuration.sh (which we call, of course).
    cat <<EOF
Usage: $0 [switch|boot|test|build]

switch: make the configuration the boot default and activate now
boot:   make the configuration the boot default
test:   activate the configuration, but don't make it the boot default
build:  build the configuration, but don't make it the default or
        activate it
EOF
    exit 1
}

if test -z "$action"; then showSyntax; fi


# Allow the location of NixOS sources and the system configuration
# file to be overridden.
if test -z "$NIXOS"; then NIXOS=/etc/nixos/nixos; fi
if test -z "$NIXOS_CONFIG"; then NIXOS_CONFIG=/etc/nixos/configuration.nix; fi


# Pull the manifests defined in the configuration (the "manifests"
# attribute).  Wonderfully hacky.
if test -z "$NIXOS_NO_PULL"; then
    manifests=$(nix-instantiate --eval-only --xml --strict $NIXOS -A manifests \
        | grep '<string'  | sed 's^.*"\(.*\)".*^\1^g')
    
    for i in $manifests; do
        NIX_DOWNLOAD_CACHE=/nix/var/nix/channel-cache nix-pull $i || true
    done
fi


# Either upgrade the configuration in the system profile (for "switch"
# or "boot"), or just build it and create a symlink "result" in the
# current directory (for "build" and "test").
if test "$action" = "switch" -o "$action" = "boot"; then
    nix-env -p /nix/var/nix/profiles/system -f $NIXOS --set -A system
    pathToConfig=/nix/var/nix/profiles/system
elif test "$action" = "test" -o "$action" = "build"; then
    nix-build $NIXOS -A system -K -k
    pathToConfig=./result
else
    showSyntax
fi


# If we're not just building, then make the new configuration the boot
# default and/or activate it now.
if test "$action" = "switch" -o "$action" = "boot" -o "$action" = "test"; then
    $pathToConfig/bin/switch-to-configuration "$action"
fi


if test "$action" = "test"; then
    cat >&2 <<EOF

Warning: if you remove or overwrite the symlink \`$pathToConfig', the
active system configuration may be garbage collected!  This may render
the system inoperable (though a reboot will fix things).
EOF
fi
