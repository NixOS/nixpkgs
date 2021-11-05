#! @runtimeShell@

set -e

# Re-exec ourselves in a private mount namespace so that our bind
# mounts get cleaned up automatically.
if [ -z "$NIXOS_ENTER_REEXEC" ]; then
    export NIXOS_ENTER_REEXEC=1
    if [ "$(id -u)" != 0 ]; then
        extraFlags="-r"
    fi
    exec unshare --fork --mount --uts --mount-proc --pid $extraFlags -- "$0" "$@"
else
    mount --make-rprivate /
fi

mountPoint=/mnt
system=/nix/var/nix/profiles/system
command=("$system/sw/bin/bash" "--login")
silent=0

while [ "$#" -gt 0 ]; do
    i="$1"; shift 1
    case "$i" in
        --root)
            mountPoint="$1"; shift 1
            ;;
        --system)
            system="$1"; shift 1
            ;;
        --help)
            exec man nixos-enter
            exit 1
            ;;
        --command|-c)
            command=("$system/sw/bin/bash" "-c" "$1")
            shift 1
            ;;
        --silent)
            silent=1
            ;;
        --)
            command=("$@")
            break
            ;;
        *)
            echo "$0: unknown option \`$i'"
            exit 1
            ;;
    esac
done

if [[ ! -e $mountPoint/etc/NIXOS ]]; then
    echo "$0: '$mountPoint' is not a NixOS installation" >&2
    exit 126
fi

mkdir -p "$mountPoint/dev" "$mountPoint/sys"
chmod 0755 "$mountPoint/dev" "$mountPoint/sys"
mount --rbind /dev "$mountPoint/dev"
mount --rbind /sys "$mountPoint/sys"

# modified from https://github.com/archlinux/arch-install-scripts/blob/bb04ab435a5a89cd5e5ee821783477bc80db797f/arch-chroot.in#L26-L52
chroot_add_resolv_conf() {
    local chrootdir=$1 resolv_conf=$1/etc/resolv.conf

    [[ -e /etc/resolv.conf ]] || return 0

    # Handle resolv.conf as a symlink to somewhere else.
    if [[ -L $chrootdir/etc/resolv.conf ]]; then
      # readlink(1) should always give us *something* since we know at this point
      # it's a symlink. For simplicity, ignore the case of nested symlinks.
      # We also ignore the possibility if `../`s escaping the root.
      resolv_conf=$(readlink "$chrootdir/etc/resolv.conf")
      if [[ $resolv_conf = /* ]]; then
        resolv_conf=$chrootdir$resolv_conf
      else
        resolv_conf=$chrootdir/etc/$resolv_conf
      fi
    fi

    # ensure file exists to bind mount over
    if [[ ! -f $resolv_conf ]]; then
      install -Dm644 /dev/null "$resolv_conf" || return 1
    fi

    mount --bind /etc/resolv.conf "$resolv_conf"
}

chroot_add_resolv_conf "$mountPoint" || print "ERROR: failed to set up resolv.conf"

(
    # If silent, write both stdout and stderr of activation script to /dev/null
    # otherwise, write both streams to stderr of this process
    if [ "$silent" -eq 1 ]; then
        exec 2>/dev/null
    fi

    # Run the activation script. Set $LOCALE_ARCHIVE to supress some Perl locale warnings.
    LOCALE_ARCHIVE="$system/sw/lib/locale/locale-archive" IN_NIXOS_ENTER=1 chroot "$mountPoint" "$system/activate" 1>&2 || true

    # Create /tmp
    chroot "$mountPoint" systemd-tmpfiles --create --remove --exclude-prefix=/dev 1>&2 || true
)

exec chroot "$mountPoint" "${command[@]}"
