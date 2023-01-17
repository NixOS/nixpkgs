#! @runtimeShell@
# shellcheck shell=bash

set -e
shopt -s nullglob

export PATH=@path@:$PATH

# Ensure a consistent umask.
umask 0022

# Parse the command line for the -I flag
extraBuildFlags=()
flakeFlags=()

mountPoint=/mnt
channelPath=
system=
verbosity=()

while [ "$#" -gt 0 ]; do
    i="$1"; shift 1
    case "$i" in
        --max-jobs|-j|--cores|-I|--substituters)
            j="$1"; shift 1
            extraBuildFlags+=("$i" "$j")
            ;;
        --option)
            j="$1"; shift 1
            k="$1"; shift 1
            extraBuildFlags+=("$i" "$j" "$k")
            ;;
        --root)
            mountPoint="$1"; shift 1
            ;;
        --system|--closure)
            system="$1"; shift 1
            ;;
        --flake)
          flake="$1"
          flakeFlags=(--experimental-features 'nix-command flakes')
          shift 1
          ;;
        --recreate-lock-file|--no-update-lock-file|--no-write-lock-file|--no-registries|--commit-lock-file)
          lockFlags+=("$i")
          ;;
        --update-input)
          j="$1"; shift 1
          lockFlags+=("$i" "$j")
          ;;
        --override-input)
          j="$1"; shift 1
          k="$1"; shift 1
          lockFlags+=("$i" "$j" "$k")
          ;;
        --channel)
            channelPath="$1"; shift 1
            ;;
        --no-channel-copy)
            noChannelCopy=1
            ;;
        --no-root-password|--no-root-passwd)
            noRootPasswd=1
            ;;
        --no-bootloader)
            noBootLoader=1
            ;;
        --show-trace|--impure|--keep-going)
            extraBuildFlags+=("$i")
            ;;
        --help)
            exec man nixos-install
            exit 1
            ;;
        --debug)
            set -x
            ;;
        -v*|--verbose)
            verbosity+=("$i")
            ;;
        *)
            echo "$0: unknown option \`$i'"
            exit 1
            ;;
    esac
done

if ! test -e "$mountPoint"; then
    echo "mount point $mountPoint doesn't exist"
    exit 1
fi

# Verify permissions are okay-enough
checkPath="$(realpath "$mountPoint")"
while [[ "$checkPath" != "/" ]]; do
    mode="$(stat -c '%a' "$checkPath")"
    if [[ "${mode: -1}" -lt "5" ]]; then
        echo "path $checkPath should have permissions 755, but had permissions $mode. Consider running 'chmod o+rx $checkPath'."
        exit 1
    fi
    checkPath="$(dirname "$checkPath")"
done

# Get the path of the NixOS configuration file.
if [[ -z $NIXOS_CONFIG ]]; then
    NIXOS_CONFIG=$mountPoint/etc/nixos/configuration.nix
fi

if [[ ${NIXOS_CONFIG:0:1} != / ]]; then
    echo "$0: \$NIXOS_CONFIG is not an absolute path"
    exit 1
fi

if [[ -n $flake ]]; then
    if [[ $flake =~ ^(.*)\#([^\#\"]*)$ ]]; then
       flake="${BASH_REMATCH[1]}"
       flakeAttr="${BASH_REMATCH[2]}"
    fi
    if [[ -z "$flakeAttr" ]]; then
        echo "Please specify the name of the NixOS configuration to be installed, as a URI fragment in the flake-uri."
        echo "For example, to use the output nixosConfigurations.foo from the flake.nix, append \"#foo\" to the flake-uri."
        exit 1
    fi
    flakeAttr="nixosConfigurations.\"$flakeAttr\""
fi

# Resolve the flake.
if [[ -n $flake ]]; then
    flake=$(nix "${flakeFlags[@]}" flake metadata --json "${extraBuildFlags[@]}" "${lockFlags[@]}" -- "$flake" | jq -r .url)
fi

if [[ ! -e $NIXOS_CONFIG && -z $system && -z $flake ]]; then
    echo "configuration file $NIXOS_CONFIG doesn't exist"
    exit 1
fi

# A place to drop temporary stuff.
tmpdir="$(mktemp -d -p "$mountPoint")"
trap 'rm -rf $tmpdir' EXIT

# store temporary files on target filesystem by default
export TMPDIR=${TMPDIR:-$tmpdir}

sub="auto?trusted=1"

# Copy the NixOS/Nixpkgs sources to the target as the initial contents
# of the NixOS channel.
if [[ -z $noChannelCopy ]]; then
    if [[ -z $channelPath ]]; then
        channelPath="$(nix-env -p /nix/var/nix/profiles/per-user/root/channels -q nixos --no-name --out-path 2>/dev/null || echo -n "")"
    fi
    if [[ -n $channelPath ]]; then
        echo "copying channel..."
        mkdir -p "$mountPoint"/nix/var/nix/profiles/per-user/root
        nix-env --store "$mountPoint" "${extraBuildFlags[@]}" --extra-substituters "$sub" \
                -p "$mountPoint"/nix/var/nix/profiles/per-user/root/channels --set "$channelPath" --quiet \
                "${verbosity[@]}"
        install -m 0700 -d "$mountPoint"/root/.nix-defexpr
        ln -sfn /nix/var/nix/profiles/per-user/root/channels "$mountPoint"/root/.nix-defexpr/channels
    fi
fi

# Build the system configuration in the target filesystem.
if [[ -z $system ]]; then
    outLink="$tmpdir/system"
    if [[ -z $flake ]]; then
        echo "building the configuration in $NIXOS_CONFIG..."
        nix-build --out-link "$outLink" --store "$mountPoint" "${extraBuildFlags[@]}" \
            --extra-substituters "$sub" \
            '<nixpkgs/nixos>' -A system -I "nixos-config=$NIXOS_CONFIG" "${verbosity[@]}"
    else
        echo "building the flake in $flake..."
        nix "${flakeFlags[@]}" build "$flake#$flakeAttr.config.system.build.toplevel" \
            --store "$mountPoint" --extra-substituters "$sub" "${verbosity[@]}" \
            "${extraBuildFlags[@]}" "${lockFlags[@]}" --out-link "$outLink"
    fi
    system=$(readlink -f "$outLink")
fi

# Set the system profile to point to the configuration. TODO: combine
# this with the previous step once we have a nix-env replacement with
# a progress bar.
nix-env --store "$mountPoint" "${extraBuildFlags[@]}" \
        --extra-substituters "$sub" \
        -p "$mountPoint"/nix/var/nix/profiles/system --set "$system" "${verbosity[@]}"

# Mark the target as a NixOS installation, otherwise switch-to-configuration will chicken out.
mkdir -m 0755 -p "$mountPoint/etc"
touch "$mountPoint/etc/NIXOS"

# Create a bind mount for each of the mount points inside the target file
# system. This preserves the validity of their absolute paths after changing
# the root with `nixos-enter`.
# Without this the bootloader installation may fail due to options that
# contain paths referenced during evaluation, like initrd.secrets.
mount --rbind --mkdir "$mountPoint" "$mountPoint$mountPoint"
mount --make-rslave "$mountPoint$mountPoint"
trap 'umount -R "$mountPoint$mountPoint" && rmdir "$mountPoint$mountPoint"' EXIT

# Switch to the new system configuration.  This will install Grub with
# a menu default pointing at the kernel/initrd/etc of the new
# configuration.
if [[ -z $noBootLoader ]]; then
    echo "installing the boot loader..."
    # Grub needs an mtab.
    ln -sfn /proc/mounts "$mountPoint"/etc/mtab
    NIXOS_INSTALL_BOOTLOADER=1 nixos-enter --root "$mountPoint" -- /run/current-system/bin/switch-to-configuration boot
fi

# Ask the user to set a root password, but only if the passwd command
# exists (i.e. when mutable user accounts are enabled).
if [[ -z $noRootPasswd ]] && [ -t 0 ]; then
    if nixos-enter --root "$mountPoint" -c 'test -e /nix/var/nix/profiles/system/sw/bin/passwd'; then
        set +e
        nixos-enter --root "$mountPoint" -c 'echo "setting root password..." && /nix/var/nix/profiles/system/sw/bin/passwd'
        exit_code=$?
        set -e

        if [[ $exit_code != 0 ]]; then
            echo "Setting a root password failed with the above printed error."
            echo "You can set the root password manually by executing \`nixos-enter --root ${mountPoint@Q}\` and then running \`passwd\` in the shell of the new system."
            exit $exit_code
        fi
    fi
fi

echo "installation finished!"
