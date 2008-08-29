#! @shell@ -e

# Allow the location of NixOS sources and the system configuration
# file to be overridden.
NIXOS=${NIXOS:-@defaultNIXOS@}
NIXPKGS=${NIXPKGS:-@defaultNIXPKGS@}
NIXOS_CONFIG=${NIXOS_CONFIG:-/etc/nixos/configuration.nix}

showSyntax() {
    # !!! more or less cut&paste from
    # system/switch-to-configuration.sh (which we call, of course).
    cat <<EOF
Usage: $0 [switch|boot|test|build|dry-run]

switch:  make the configuration the boot default and activate now
boot:    make the configuration the boot default
test:    activate the configuration, but don't make it the boot default
build:   build the configuration, but don't make it the default or
         activate it
dry-run: just show what store paths would be built/downloaded

Environment variables affecting nixos-rebuild:

  Path to NixOS:         NIXOS=${NIXOS}
  Path to Nixpkgs:       NIXPKGS=${NIXPKGS}
  Path to configuration: NIXOS_CONFIG=${NIXOS_CONFIG}
EOF
    exit 1
}


# Parse the command line.
extraBuildFlags=
action=

for i in "$@"; do
    if test "$i" = "--help"; then
        showSyntax
    elif test "$i" = switch -o "$i" = boot -o "$i" = test -o "$i" = build -o "$i" = dry-run; then
        action="$i"
    else
        echo "$0: unknown option \`$i'"
        exit 1
    fi
done

if test -z "$action"; then showSyntax; fi

if test "$action" = dry-run; then
    extraBuildFlags="$extraBuildFlags --dry-run"
fi


# If the Nix daemon is running, then use it.  This allows us to use
# the latest Nix from Nixpkgs (below) for expression evaluation, while
# still using the old Nix (via the daemon) for actual store access.
# This matters if the new Nix in Nixpkgs has a schema change.  It
# would upgrade the schema, which should only happen once we actually
# switch to the new configuration.
if initctl status nix-daemon 2>&1 | grep -q ' running'; then
    export NIX_REMOTE=${NIX_REMOTE:-daemon}
fi


# Pull the manifests defined in the configuration (the "manifests"
# attribute).  Wonderfully hacky.
if test "${NIXOS_PULL:-1}" != 0; then
    manifests=$(nix-instantiate --eval-only --xml --strict $NIXOS -A manifests \
        | grep '<string'  | sed 's^.*"\(.*\)".*^\1^g')

    mkdir -p /nix/var/nix/channel-cache
    for i in $manifests; do
        NIX_DOWNLOAD_CACHE=/nix/var/nix/channel-cache nix-pull $i || true
    done
fi


# First build Nix, since NixOS may require a newer version than the
# current one.  Of course, the same goes for Nixpkgs, but Nixpkgs is
# more conservative.
if test "${NIXOS_BUILD_NIX:-1}" != 0; then
    if ! nix-build $NIXOS -A nixFallback -o $HOME/nix-tmp; then
        nix-build $NIXPKGS -A nixUnstable -o $HOME/nix-tmp
    fi
    PATH=$HOME/nix-tmp/bin:$PATH
fi


# Either upgrade the configuration in the system profile (for "switch"
# or "boot"), or just build it and create a symlink "result" in the
# current directory (for "build" and "test").
if test "$action" = switch -o "$action" = boot; then
    nix-env -p /nix/var/nix/profiles/system -f $NIXOS --set -A system $extraBuildFlags
    pathToConfig=/nix/var/nix/profiles/system
elif test "$action" = test -o "$action" = build -o "$action" = dry-run; then
    nix-build $NIXOS -A system -K -k $extraBuildFlags
    pathToConfig=./result
else
    showSyntax
fi


# If we're not just building, then make the new configuration the boot
# default and/or activate it now.
if test "$action" = switch -o "$action" = boot -o "$action" = test; then
    $pathToConfig/bin/switch-to-configuration "$action"
fi


if test "$action" = "test"; then
    cat >&2 <<EOF

Warning: if you remove or overwrite the symlink \`$pathToConfig', the
active system configuration may be garbage collected!  This may render
the system inoperable (though a reboot will fix things).
EOF
fi


rm -f $HOME/nix-tmp
