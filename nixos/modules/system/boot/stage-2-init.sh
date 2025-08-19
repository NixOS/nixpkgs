#! @shell@

systemConfig=@systemConfig@

export HOME=/root PATH="@path@"


if [ "${IN_NIXOS_SYSTEMD_STAGE1:-}" != true ]; then
    # Process the kernel command line.
    for o in $(</proc/cmdline); do
        case $o in
            boot.debugtrace)
                # Show each command.
                set -x
                ;;
        esac
    done


    # Print a greeting.
    echo
    echo -e "\e[1;32m<<< @distroName@ Stage 2 >>>\e[0m"
    echo


    # Normally, stage 1 mounts the root filesystem read/writable.
    # However, in some environments, stage 2 is executed directly, and the
    # root is read-only.  So make it writable here.
    if [ -z "$container" ]; then
        mount -n -o remount,rw none /
    fi
fi


# Likewise, stage 1 mounts /proc, /dev and /sys, so if we don't have a
# stage 1, we need to do that here.
if [ ! -e /proc/1 ]; then
    specialMount() {
        local device="$1"
        local mountPoint="$2"
        local options="$3"
        local fsType="$4"

        # We must not overwrite this mount because it's bind-mounted
        # from stage 1's /run
        if [ "${IN_NIXOS_SYSTEMD_STAGE1:-}" = true ] && [ "${mountPoint}" = /run ]; then
            return
        fi

        install -m 0755 -d "$mountPoint"
        mount -n -t "$fsType" -o "$options" "$device" "$mountPoint"
    }
    source @earlyMountScript@
fi


if [ "${IN_NIXOS_SYSTEMD_STAGE1:-}" = true ] || [ ! -c /dev/kmsg ] ; then
    echo "booting system configuration ${systemConfig}"
else
    echo "booting system configuration $systemConfig" > /dev/kmsg
fi


# Give /nix/store the defined mount options.
# Typically, this should be:
# - 'ro' to enforce immutability of the Nix store
# - 'nosuid' to enforce no suid binaries make it into the store and get executed by accident.
#   suid-binaries should only exist in /run/wrappers.
#   If an attacker can make the nix builder produce suid binaries in the store, those should be useless.
#   Another example is tampering with the store from an outside system.
# - 'nodev' to enforce no device files in the store
# Note that we can't use "chown root:nixbld" here
# because users/groups might not exist yet.

# Silence chown/chmod to fail gracefully on a readonly filesystem
# like squashfs.
chown -f 0:30000 /nix/store
chmod -f 1775 /nix/store

missing_opts=() # stores the missing mount options that still need to be applied to the nix store
current_opts="$(findmnt --direction backward --first-only --noheadings --output OPTIONS /nix/store)"
for mount_opt in @nixStoreMountOpts@ ; do
    # #375257: Ensure that we pick the "top" (i.e. last) mount so we don't get a false positive for a lower mount.
    # matches '$opt', foo,$opt', '$opt,foo', 'foo,$opt,bar'
    # crucially, it does not match 'foo$opt', otherwise e.g. 'errors=remount-ro' would yield false positives for 'ro'
    if ! [[ "$current_opts" =~ (^|,)"$mount_opt"(,|$) ]]; then
        missing_opts+=("$mount_opt")
    fi
done

# only change the mount options if any need changing
if [[ ${#missing_opts[@]} != 0 ]]; then
    if [ -z "$container" ]; then
        mount --bind /nix/store /nix/store
    else
        mount --rbind /nix/store /nix/store
    fi

    # apply the missing mount options
    mount -o remount,"$(IFS=, ; echo "${missing_opts[*]}")",bind /nix/store
fi

if [ "${IN_NIXOS_SYSTEMD_STAGE1:-}" != true ]; then
    # Use /etc/resolv.conf supplied by systemd-nspawn, if applicable.
    if [ -n "@useHostResolvConf@" ] && [ -e /etc/resolv.conf ]; then
        resolvconf -m 1000 -a host </etc/resolv.conf
    fi


    # Log the script output to /dev/kmsg or /run/log/stage-2-init.log.
    # Only at this point are all the necessary prerequisites ready for these commands.
    exec {logOutFd}>&1 {logErrFd}>&2
    if test -w /dev/kmsg; then
        exec > >(tee -i /proc/self/fd/"$logOutFd" | while read -r line; do
            if test -n "$line"; then
                echo "<7>stage-2-init: $line" > /dev/kmsg
            fi
        done) 2>&1
    else
        mkdir -p /run/log
        exec > >(tee -i /run/log/stage-2-init.log) 2>&1
    fi
fi


# Required by the activation script
install -m 0755 -d /etc
if [ ! -h "/etc/nixos" ]; then
    install -m 0755 -d /etc/nixos
fi
install -m 01777 -d /tmp


# Run the script that performs all configuration activation that does
# not have to be done at boot time.
echo "running activation script..."
$systemConfig/activate


# Record the boot configuration.
ln -sfn "$systemConfig" /run/booted-system


# Run any user-specified commands.
@shell@ @postBootCommands@


# No need to restore the stdout/stderr streams we never redirected and
# especially no need to start systemd
if [ "${IN_NIXOS_SYSTEMD_STAGE1:-}" != true ]; then
    # Reset the logging file descriptors.
    exec 1>&$logOutFd 2>&$logErrFd
    exec {logOutFd}>&- {logErrFd}>&-


    # Start systemd in a clean environment.
    echo "starting systemd..."
    exec @systemdExecutable@ "$@"
fi
