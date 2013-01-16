#! @shell@ -e

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
  build-vm-with-bootloader:
            like build-vm, but include a boot loader in the VM
  dry-run:  just show what store paths would be built/downloaded

Options:

  --upgrade              fetch the latest version of NixOS before rebuilding
  --install-grub         (re-)install the Grub bootloader
  --no-build-nix         don't build the latest Nix from Nixpkgs before
                         building NixOS
  --rollback             restore the previous NixOS configuration (only
                         with switch, boot, test, build)

  --fast                 same as --no-build-nix --show-trace

Various nix-build options are also accepted, in particular:

  --show-trace           show a detailed stack trace for evaluation errors

Environment variables affecting nixos-rebuild:

  \$NIX_PATH              Nix expression search path
  \$NIXOS_CONFIG          path to the NixOS system configuration specification
EOF
    exit 1
}


# Parse the command line.
extraBuildFlags=()
action=
buildNix=1
rollback=
upgrade=

while [ "$#" -gt 0 ]; do
    i="$1"; shift 1
    case "$i" in
      --help)
        showSyntax
        ;;
      switch|boot|test|build|dry-run|build-vm|build-vm-with-bootloader)
        action="$i"
        ;;
      --install-grub)
        export NIXOS_INSTALL_GRUB=1
        ;;
      --no-build-nix)
        buildNix=
        ;;
      --rollback)
        rollback=1
        ;;
      --upgrade)
        upgrade=1
        ;;
      --show-trace|--no-build-hook|--keep-failed|-K|--keep-going|-k|--verbose|-v|--fallback)
        extraBuildFlags+=("$i")
        ;;
      --max-jobs|-j|--cores|-I)
        j="$1"; shift 1
        extraBuildFlags+=("$i" "$j")
        ;;
      --option)
        j="$1"; shift 1
        k="$1"; shift 1
        extraBuildFlags+=("$i" "$j" "$k")
        ;;
      --fast)
        buildNix=
        extraBuildFlags+=(--show-trace)
        ;;
      *)
        echo "$0: unknown option \`$i'"
        exit 1
        ;;
    esac
done

if [ -z "$action" ]; then showSyntax; fi

if [ -n "$rollback" ]; then
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
if systemctl show nix-daemon.socket nix-daemon.service | grep -q ActiveState=active; then
    export NIX_REMOTE=${NIX_REMOTE:-daemon}
fi


# If ‘--upgrade’ is given, run ‘nix-channel --update nixos’.
if [ -n "$upgrade" ]; then
    nix-channel --update nixos
fi


# First build Nix, since NixOS may require a newer version than the
# current one.  Of course, the same goes for Nixpkgs, but Nixpkgs is
# more conservative.
if [ "$action" != dry-run -a -n "$buildNix" ]; then
    echo "building Nix..." >&2
    if ! nix-build '<nixos>' -A config.environment.nix -o $tmpDir/nix "${extraBuildFlags[@]}" > /dev/null; then
        if ! nix-build '<nixos>' -A nixFallback -o $tmpDir/nix "${extraBuildFlags[@]}" > /dev/null; then
            nix-build '<nixpkgs>' -A nixUnstable -o $tmpDir/nix "${extraBuildFlags[@]}" > /dev/null
        fi
    fi
    PATH=$tmpDir/nix/bin:$PATH
fi


# Update the version suffix if we're building from Git (so that
# nixos-version shows something useful).
if nixos=$(nix-instantiate --find-file nixos "${extraBuildFlags[@]}"); then
    suffix=$($SHELL $nixos/modules/installer/tools/get-version-suffix "${extraBuildFlags[@]}")
    if [ -n "$suffix" ]; then
        echo -n "$suffix" > "$nixos/.version-suffix"
    fi
fi


if [ "$action" = dry-run ]; then
    extraBuildFlags+=(--dry-run)
fi


# Either upgrade the configuration in the system profile (for "switch"
# or "boot"), or just build it and create a symlink "result" in the
# current directory (for "build" and "test").
if [ -z "$rollback" ]; then
    echo "building the system configuration..." >&2
    if [ "$action" = switch -o "$action" = boot ]; then
        nix-env "${extraBuildFlags[@]}" -p /nix/var/nix/profiles/system -f '<nixos>' --set -A system
        pathToConfig=/nix/var/nix/profiles/system
    elif [ "$action" = test -o "$action" = build -o "$action" = dry-run ]; then
        nix-build '<nixos>' -A system -K -k "${extraBuildFlags[@]}" > /dev/null
        pathToConfig=./result
    elif [ "$action" = build-vm ]; then
        nix-build '<nixos>' -A vm -K -k "${extraBuildFlags[@]}" > /dev/null
        pathToConfig=./result
    elif [ "$action" = build-vm-with-bootloader ]; then
        nix-build '<nixos>' -A vmWithBootLoader -K -k "${extraBuildFlags[@]}" > /dev/null
        pathToConfig=./result
    else
        showSyntax
    fi
else # [ -n "$rollback" ]
    if [ "$action" = switch -o "$action" = boot ]; then
        nix-env --rollback -p /nix/var/nix/profiles/system
        pathToConfig=/nix/var/nix/profiles/system
    elif [ "$action" = test -o "$action" = build ]; then
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
if [ "$action" = switch -o "$action" = boot -o "$action" = test ]; then
    # Just in case the new configuration hangs the system, do a sync now.
    sync

    $pathToConfig/bin/switch-to-configuration "$action"
fi


if [ "$action" = build-vm ]; then
    cat >&2 <<EOF

Done.  The virtual machine can be started by running $(echo $pathToConfig/bin/run-*-vm).
EOF
fi
