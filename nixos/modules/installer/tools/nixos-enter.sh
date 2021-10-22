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
