#! @shell@

if [ -x "@shell@" ]; then export SHELL="@shell@"; fi;

set -e

showSyntax() {
    exec man nixos-rebuild
    exit 1
}


# Parse the command line.
origArgs=("$@")
extraBuildFlags=()
action=
buildNix=1
rollback=
upgrade=
repair=
profile=/nix/var/nix/profiles/system
buildHost=
targetHost=

while [ "$#" -gt 0 ]; do
    i="$1"; shift 1
    case "$i" in
      --help)
        showSyntax
        ;;
      switch|boot|test|build|dry-build|dry-run|dry-activate|build-vm|build-vm-with-bootloader)
        if [ "$i" = dry-run ]; then i=dry-build; fi
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
      --show-trace|--no-build-hook|--keep-failed|-K|--keep-going|-k|--verbose|-v|-vv|-vvv|-vvvv|-vvvvv|--fallback|--repair|--no-build-output|-Q)
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
      --build-host|h)
        buildHost="$1"
        shift 1
        ;;
      --target-host|t)
        targetHost="$1"
        shift 1
        ;;
      *)
        echo "$0: unknown option \`$i'"
        exit 1
        ;;
    esac
done


if [ -z "$buildHost" -a -n "$targetHost" ]; then
    buildHost="$targetHost"
fi
if [ "$targetHost" = localhost ]; then
    targetHost=
fi
if [ "$buildHost" = localhost ]; then
    buildHost=
fi

buildHostCmd() {
    if [ -z "$buildHost" ]; then
        "$@"
    elif [ -n "$remoteNix" ]; then
        ssh $SSHOPTS "$buildHost" PATH="$remoteNix:$PATH" "$@"
    else
        ssh $SSHOPTS "$buildHost" "$@"
    fi
}

targetHostCmd() {
    if [ -z "$targetHost" ]; then
        "$@"
    else
        ssh $SSHOPTS "$targetHost" "$@"
    fi
}

copyToTarget() {
    if ! [ "$targetHost" = "$buildHost" ]; then
        if [ -z "$targetHost" ]; then
            NIX_SSHOPTS=$SSH_OPTS nix-copy-closure --from "$buildHost" "$1"
        elif [ -z "$buildHost" ]; then
            NIX_SSHOPTS=$SSH_OPTS nix-copy-closure --to "$targetHost" "$1"
        else
            buildHostCmd nix-copy-closure --to "$targetHost" "$1"
        fi
    fi
}

nixBuild() {
    if [ -z "$buildHost" ]; then
        nix-build "$@"
    else
        local instArgs=()
        local buildArgs=()

        while [ "$#" -gt 0 ]; do
            local i="$1"; shift 1
            case "$i" in
              -o)
                local out="$1"; shift 1
                buildArgs+=("--add-root" "$out" "--indirect")
                ;;
              -A)
                local j="$1"; shift 1
                instArgs+=("$i" "$j")
                ;;
              -I) # We don't want this in buildArgs
                shift 1
                ;;
              --no-out-link) # We don't want this in buildArgs
                ;;
              "<"*) # nix paths
                instArgs+=("$i")
                ;;
              *)
                buildArgs+=("$i")
                ;;
            esac
        done

        local drv="$(nix-instantiate "${instArgs[@]}" "${extraBuildFlags[@]}")"
        if [ -a "$drv" ]; then
            NIX_SSHOPTS=$SSH_OPTS nix-copy-closure --to "$buildHost" "$drv"
            buildHostCmd nix-store -r "$drv" "${buildArgs[@]}"
        else
            echo "nix-instantiate failed"
            exit 1
        fi
  fi
}


if [ -z "$action" ]; then showSyntax; fi

# Only run shell scripts from the Nixpkgs tree if the action is
# "switch", "boot", or "test". With other actions (such as "build"),
# the user may reasonably expect that no code from the Nixpkgs tree is
# executed, so it's safe to run nixos-rebuild against a potentially
# untrusted tree.
canRun=
if [ "$action" = switch -o "$action" = boot -o "$action" = test ]; then
    canRun=1
fi


# If ‘--upgrade’ is given, run ‘nix-channel --update nixos’.
if [ -n "$upgrade" -a -z "$_NIXOS_REBUILD_REEXEC" ]; then
    nix-channel --update nixos

    # If there are other channels that contain a file called
    # ".update-on-nixos-rebuild", update them as well.
    for channelpath in /nix/var/nix/profiles/per-user/root/channels/*; do
        if [ -e "$channelpath/.update-on-nixos-rebuild" ]; then
            nix-channel --update "$(basename "$channelpath")"
        fi
    done
fi

# Make sure that we use the Nix package we depend on, not something
# else from the PATH for nix-{env,instantiate,build}.  This is
# important, because NixOS defaults the architecture of the rebuilt
# system to the architecture of the nix-* binaries used.  So if on an
# amd64 system the user has an i686 Nix package in her PATH, then we
# would silently downgrade the whole system to be i686 NixOS on the
# next reboot.
if [ -z "$_NIXOS_REBUILD_REEXEC" ]; then
    export PATH=@nix@/bin:$PATH
fi

# Re-execute nixos-rebuild from the Nixpkgs tree.
if [ -z "$_NIXOS_REBUILD_REEXEC" -a -n "$canRun" ]; then
    if p=$(nix-instantiate --find-file nixpkgs/nixos/modules/installer/tools/nixos-rebuild.sh "${extraBuildFlags[@]}"); then
        export _NIXOS_REBUILD_REEXEC=1
        exec $SHELL -e $p "${origArgs[@]}"
        exit 1
    fi
fi


tmpDir=$(mktemp -t -d nixos-rebuild.XXXXXX)
SSHOPTS="$NIX_SSHOPTS -o ControlMaster=auto -o ControlPath=$tmpDir/ssh-%n -o ControlPersist=60"

cleanup() {
    for ctrl in "$tmpDir"/ssh-*; do
        ssh -o ControlPath="$ctrl" -O exit dummyhost 2>/dev/null || true
    done
    rm -rf "$tmpDir"
}
trap cleanup EXIT



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


# First build Nix, since NixOS may require a newer version than the
# current one.
if [ -n "$rollback" -o "$action" = dry-build ]; then
    buildNix=
fi

prebuiltNix() {
    machine="$1"
    if [ "$machine" = x86_64 ]; then
        echo /nix/store/xryr9g56h8yjddp89d6dw12anyb4ch7c-nix-1.10
    elif [[ "$machine" =~ i.86 ]]; then
        echo /nix/store/2w92k5wlpspf0q2k9mnf2z42prx3bwmv-nix-1.10
    else
        echo "$0: unsupported platform"
        exit 1
    fi
}

remotePATH=

if [ -n "$buildNix" ]; then
    echo "building Nix..." >&2
    nixDrv=
    if ! nixDrv="$(nix-instantiate '<nixpkgs/nixos>' --add-root $tmpDir/nix.drv --indirect -A config.nix.package.out "${extraBuildFlags[@]}")"; then
        if ! nixDrv="$(nix-instantiate '<nixpkgs/nixos>' --add-root $tmpDir/nix.drv --indirect -A nixFallback "${extraBuildFlags[@]}")"; then
            if ! nixDrv="$(nix-instantiate '<nixpkgs>' --add-root $tmpDir/nix.drv --indirect -A nix "${extraBuildFlags[@]}")"; then
                nixStorePath="$(prebuiltNix "$(uname -m)")"
                if ! nix-store -r $nixStorePath --add-root $tmpDir/nix --indirect \
                    --option extra-binary-caches https://cache.nixos.org/; then
                    echo "warning: don't know how to get latest Nix" >&2
                fi
                # Older version of nix-store -r don't support --add-root.
                [ -e $tmpDir/nix ] || ln -sf $nixStorePath $tmpDir/nix
                if [ -n "$buildHost" ]; then
                    remoteNixStorePath="$(prebuiltNix "$(buildHostCmd uname -m)")"
                    remoteNix="$remoteNixStorePath/bin"
                    if ! buildHostCmd nix-store -r $remoteNixStorePath \
                      --option extra-binary-caches https://cache.nixos.org/ >/dev/null; then
                        remoteNix=
                        echo "warning: don't know how to get latest Nix" >&2
                    fi
                fi
            fi
        fi
    fi
    if [ -a "$nixDrv" ]; then
        nix-store -r "$nixDrv"'!'"out" --add-root $tmpDir/nix --indirect >/dev/null
        if [ -n "$buildHost" ]; then
            nix-copy-closure --to "$buildHost" "$nixDrv"
            # The nix build produces multiple outputs, we add them all to the remote path
            for p in $(buildHostCmd nix-store -r "$(readlink "$nixDrv")" "${buildArgs[@]}"); do
                remoteNix="$remoteNix${remoteNix:+:}$p/bin"
            done
        fi
    fi
    PATH="$tmpDir/nix/bin:$PATH"
fi


# Update the version suffix if we're building from Git (so that
# nixos-version shows something useful).
if [ -n "$canRun" ]; then
    if nixpkgs=$(nix-instantiate --find-file nixpkgs "${extraBuildFlags[@]}"); then
        suffix=$($SHELL $nixpkgs/nixos/modules/installer/tools/get-version-suffix "${extraBuildFlags[@]}" || true)
        if [ -n "$suffix" ]; then
            echo -n "$suffix" > "$nixpkgs/.version-suffix" || true
        fi
    fi
fi


if [ "$action" = dry-build ]; then
    extraBuildFlags+=(--dry-run)
fi


# Either upgrade the configuration in the system profile (for "switch"
# or "boot"), or just build it and create a symlink "result" in the
# current directory (for "build" and "test").
if [ -z "$rollback" ]; then
    echo "building the system configuration..." >&2
    if [ "$action" = switch -o "$action" = boot ]; then
        pathToConfig="$(nixBuild '<nixpkgs/nixos>' --no-out-link -A system "${extraBuildFlags[@]}")"
        copyToTarget "$pathToConfig"
        targetHostCmd nix-env -p "$profile" --set "$pathToConfig"
    elif [ "$action" = test -o "$action" = build -o "$action" = dry-build -o "$action" = dry-activate ]; then
        pathToConfig="$(nixBuild '<nixpkgs/nixos>' -A system -k "${extraBuildFlags[@]}")"
    elif [ "$action" = build-vm ]; then
        pathToConfig="$(nixBuild '<nixpkgs/nixos>' -A vm -k "${extraBuildFlags[@]}")"
    elif [ "$action" = build-vm-with-bootloader ]; then
        pathToConfig="$(nixBuild '<nixpkgs/nixos>' -A vmWithBootLoader -k "${extraBuildFlags[@]}")"
    else
        showSyntax
    fi
    # Copy build to target host if we haven't already done it
    if ! [ "$action" = switch -o "$action" = boot ]; then
        copyToTarget "$pathToConfig"
    fi
else # [ -n "$rollback" ]
    if [ "$action" = switch -o "$action" = boot ]; then
        targetHostCmd nix-env --rollback -p "$profile"
        pathToConfig="$profile"
    elif [ "$action" = test -o "$action" = build ]; then
        systemNumber=$(
            targetHostCmd nix-env -p "$profile" --list-generations |
            sed -n '/current/ {g; p;}; s/ *\([0-9]*\).*/\1/; h'
        )
        pathToConfig="$profile"-${systemNumber}-link
        if [ -z "$targetHost" ]; then
            ln -sT "$pathToConfig" ./result
        fi
    else
        showSyntax
    fi
fi


# If we're not just building, then make the new configuration the boot
# default and/or activate it now.
if [ "$action" = switch -o "$action" = boot -o "$action" = test -o "$action" = dry-activate ]; then
    if ! targetHostCmd $pathToConfig/bin/switch-to-configuration "$action"; then
        echo "warning: error(s) occurred while switching to the new configuration" >&2
        exit 1
    fi
fi


if [ "$action" = build-vm ]; then
    cat >&2 <<EOF

Done.  The virtual machine can be started by running $(echo $pathToConfig/bin/run-*-vm).
EOF
fi
