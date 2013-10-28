#! @shell@ -e

showSyntax() {
    exec man nixos-rebuild
    exit 1
}


# Parse the command line.
extraBuildFlags=()
action=
buildNix=1
rollback=
upgrade=
repair=
profile=/nix/var/nix/profiles/system

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
      --repair)
        repair=1
        extraBuildFlags+=("$i")
        ;;
      --show-trace|--no-build-hook|--keep-failed|-K|--keep-going|-k|--verbose|-v|-vv|-vvv|-vvvv|-vvvvv|--fallback|--repair)
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
      --profile-name|-p)
        if [ -z "$1" ]; then
            echo "$0: ‘--profile-name’ requires an argument"
            exit 1
        fi
        if [ "$1" != system ]; then
            profile="/nix/var/nix/profiles/system-profiles/$1"
            mkdir -p -m 0755 "$(dirname "$profile")"
        fi
        shift 1
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
# If --repair is given, don't try to use the Nix daemon, because the
# flag can only be used directly.
if [ -z "$repair" ] && systemctl show nix-daemon.socket nix-daemon.service | grep -q ActiveState=active; then
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
    if ! nix-build '<nixpkgs/nixos>' -A config.nix.package -o $tmpDir/nix "${extraBuildFlags[@]}" > /dev/null; then
        if ! nix-build '<nixpkgs/nixos>' -A nixFallback -o $tmpDir/nix "${extraBuildFlags[@]}" > /dev/null; then
            nix-build '<nixpkgs>' -A nixUnstable -o $tmpDir/nix "${extraBuildFlags[@]}" > /dev/null
        fi
    fi
    PATH=$tmpDir/nix/bin:$PATH
fi


# Update the version suffix if we're building from Git (so that
# nixos-version shows something useful).
if nixpkgs=$(nix-instantiate --find-file nixpkgs "${extraBuildFlags[@]}"); then
    suffix=$(@shell@ $nixpkgs/nixos/modules/installer/tools/get-version-suffix "${extraBuildFlags[@]}")
    if [ -n "$suffix" ]; then
        echo -n "$suffix" > "$nixpkgs/.version-suffix" || true
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
        nix-env "${extraBuildFlags[@]}" -p "$profile" -f '<nixpkgs/nixos>' --set -A system
        pathToConfig="$profile"
    elif [ "$action" = test -o "$action" = build -o "$action" = dry-run ]; then
        nix-build '<nixpkgs/nixos>' -A system -K -k "${extraBuildFlags[@]}" > /dev/null
        pathToConfig=./result
    elif [ "$action" = build-vm ]; then
        nix-build '<nixpkgs/nixos>' -A vm -K -k "${extraBuildFlags[@]}" > /dev/null
        pathToConfig=./result
    elif [ "$action" = build-vm-with-bootloader ]; then
        nix-build '<nixpkgs/nixos>' -A vmWithBootLoader -K -k "${extraBuildFlags[@]}" > /dev/null
        pathToConfig=./result
    else
        showSyntax
    fi
else # [ -n "$rollback" ]
    if [ "$action" = switch -o "$action" = boot ]; then
        nix-env --rollback -p "$profile"
        pathToConfig="$profile"
    elif [ "$action" = test -o "$action" = build ]; then
        systemNumber=$(
            nix-env -p "$profile" --list-generations |
            sed -n '/current/ {g; p;}; s/ *\([0-9]*\).*/\1/; h'
        )
        ln -sT "$profile"-${systemNumber}-link ./result
        pathToConfig=./result
    else
        showSyntax
    fi
fi


# If we're not just building, then make the new configuration the boot
# default and/or activate it now.
if [ "$action" = switch -o "$action" = boot -o "$action" = test ]; then
    $pathToConfig/bin/switch-to-configuration "$action"
fi


if [ "$action" = build-vm ]; then
    cat >&2 <<EOF

Done.  The virtual machine can be started by running $(echo $pathToConfig/bin/run-*-vm).
EOF
fi
