#! @shell@ -e

# Allow the location of NixOS sources and the system configuration
# file to be overridden.
NIXOS=${NIXOS:-/etc/nixos/nixos}
NIXPKGS=${NIXPKGS:-/etc/nixos/nixpkgs}
NIXOS_CONFIG=${NIXOS_CONFIG:-/etc/nixos/configuration.nix}
export NIXPKGS # must be exported so that a non default location is passed to nixos/default.nix

showSyntax() {
    # !!! more or less cut&paste from
    # system/switch-to-configuration.sh (which we call, of course).
    cat <<EOF
Usage: $0 [OPTIONS...] OPERATION

The operation is one of the following:

  switch:   make the configuration the boot default and activate now
  boot:     make the configuration the boot default
  test:     activate the configuration, but don't make it the boot default
  build:    build the configuration, but don't make it the default or
            activate it
  build-vm: build a virtual machine containing the configuration
            (useful for testing)
  dry-run:  just show what store paths would be built/downloaded

Options:

  --install-grub         (re-)install the Grub bootloader
  --no-pull              don't do a nix-pull to get the latest Nixpkgs
                         channel manifest
  --no-build-nix         don't build the latest Nix from Nixpkgs before
                         building NixOS
  --rollback             restore the previous NixOS configuration (only
                         with switch, boot, test, build)

  --redo                 same as --no-pull --no-build-nix --show-trace

Various nix-build options are also accepted, in particular:

  --show-trace           show a detailed stack trace for evaluation errors
 
Environment variables affecting nixos-rebuild:

  \$NIXOS                 path to the NixOS source tree
  \$NIXPKGS               path to the Nixpkgs source tree
  \$NIXOS_CONFIG          path to the NixOS system configuration specification
EOF
    exit 1
}


# Parse the command line.
extraBuildFlags=
action=
pullManifest=1
buildNix=1
rollback=

while test "$#" -gt 0; do
    i="$1"; shift 1
    if test "$i" = "--help"; then
        showSyntax
    elif test "$i" = switch -o "$i" = boot -o "$i" = test -o "$i" = build \
        -o "$i" = dry-run -o "$i" = build-vm; then
        action="$i"
    elif test "$i" = --install-grub; then
        export NIXOS_INSTALL_GRUB=1
    elif test "$i" = --no-pull; then
        pullManifest=
    elif test "$i" = --no-build-nix; then
        buildNix=
    elif test "$i" = --rollback; then
        rollback=1
    elif test "$i" = --show-trace -o "$i" = --no-build-hook -o "$i" = --keep-failed -o "$i" = -K \
        -o "$i" = --keep-going -o "$i" = -k -o "$i" = --verbose -o "$i" = -v; then
        extraBuildFlags="$extraBuildFlags $i"
    elif test "$i" = --max-jobs -o "$i" = -j; then
        j="$1"; shift 1
        extraBuildFlags="$extraBuildFlags $i $j"
    elif test "$i" = --redo; then
        buildNix=
        pullManifest=
        extraBuildFlags="$extraBuildFlags --show-trace"
    else
        echo "$0: unknown option \`$i'"
        exit 1
    fi
done

if test -z "$action"; then showSyntax; fi

if test "$action" = dry-run; then
    extraBuildFlags="$extraBuildFlags --dry-run"
fi

if test -n "$rollback"; then
    pullManifest=
    buildNix=
fi


tmpDir=$(mktemp -t -d nixos-rebuild.XXXXXX)
trap 'rm -rf "$tmpDir"' EXIT


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
if test -n "$pullManifest"; then
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
if test -n "$buildNix"; then
    if ! nix-build $NIXOS -A nixFallback -o $tmpDir/nix; then
        nix-build $NIXPKGS -A nixUnstable -o $tmpDir/nix
    fi
    PATH=$tmpDir/nix/bin:$PATH
fi


# Either upgrade the configuration in the system profile (for "switch"
# or "boot"), or just build it and create a symlink "result" in the
# current directory (for "build" and "test").
if test -z "$rollback"; then
    if test "$action" = switch -o "$action" = boot; then
        nix-env -p /nix/var/nix/profiles/system -f $NIXOS --set -A system $extraBuildFlags
        pathToConfig=/nix/var/nix/profiles/system
    elif test "$action" = test -o "$action" = build -o "$action" = dry-run; then
        nix-build $NIXOS -A system -K -k $extraBuildFlags
        pathToConfig=./result
    elif test "$action" = build-vm; then
        nix-build $NIXOS -A vm -K -k $extraBuildFlags
        pathToConfig=./result
    else
        showSyntax
    fi
else # test -n "$rollback"
    if test "$action" = switch -o "$action" = boot; then
        nix-env --rollback -p /nix/var/nix/profiles/system
        pathToConfig=/nix/var/nix/profiles/system
    elif test "$action" = test -o "$action" = build; then
        systemNumber=$(
            nix-env -p /nix/var/nix/profiles/system --list-generations |
            sed -n '/current/ {g; p;}; s/ *\([0-9]*\).*/\1/; h'
        )
        ln -sT /nix/var/nix/profiles/system-${systemNumber}-link ./result
        pathToConfig=./result
    else
        showSyntax
    fi
fi


# If we're not just building, then make the new configuration the boot
# default and/or activate it now.
if test "$action" = switch -o "$action" = boot -o "$action" = test; then
    $pathToConfig/bin/switch-to-configuration "$action"
fi


if test "$action" = test; then
    cat >&2 <<EOF

Warning: if you remove or overwrite the symlink \`$pathToConfig', the
active system configuration may be garbage collected!  This may render
the system inoperable (though a reboot will fix things).
EOF
fi


if test "$action" = build-vm; then
    cat >&2 <<EOF

Done.  The virtual machine can be started by running $(echo $pathToConfig/bin/run-*-vm).
EOF
fi
