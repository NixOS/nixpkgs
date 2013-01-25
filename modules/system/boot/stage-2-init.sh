#! @shell@

systemConfig=@systemConfig@

export HOME=/root


# Print a greeting.
echo
echo -e "\e[1;32m<<< NixOS Stage 2 >>>\e[0m"
echo


# Set the PATH.
setPath() {
    local dirs="$1"
    export PATH=/empty
    for i in $dirs; do
        PATH=$PATH:$i/bin
        if test -e $i/sbin; then
            PATH=$PATH:$i/sbin
        fi
    done
}

setPath "@path@"


# Normally, stage 1 mounts the root filesystem read/writable.
# However, in some environments, stage 2 is executed directly, and the
# root is read-only.  So make it writable here.
mount -n -o remount,rw /


# Likewise, stage 1 mounts /proc, /dev and /sys, so if we don't have a
# stage 1, we need to do that here.
if [ ! -e /proc/1 ]; then
    mkdir -m 0755 -p /proc
    mount -n -t proc none /proc
    mkdir -m 0755 -p /dev
    mount -t devtmpfs none /dev
fi


# Make /nix/store a read-only bind mount to enforce immutability of
# the Nix store.  Note that we can't use "chown root:nixbld" here
# because users/groups might not exist yet.
chown 0:30000 /nix/store
chmod 1775 /nix/store
if [ -n "@readOnlyStore@" ]; then
    if ! mountpoint -q /nix/store; then
        mount --bind /nix/store /nix/store
        mount -o remount,ro,bind /nix/store
    fi
fi


# Provide a /etc/mtab.
mkdir -m 0755 -p /etc
test -e /etc/fstab || touch /etc/fstab # to shut up mount
rm -f /etc/mtab* # not that we care about stale locks
ln -s /proc/mounts /etc/mtab


# Process the kernel command line.
for o in $(cat /proc/cmdline); do
    case $o in
        boot.debugtrace)
            # Show each command.
            set -x
            ;;
        resume=*)
            set -- $(IFS==; echo $o)
            resumeDevice=$2
            ;;
    esac
done


# More special file systems, initialise required directories.
mkdir -m 0755 /dev/shm
mount -t tmpfs -o "rw,nosuid,nodev,size=@devShmSize@" tmpfs /dev/shm
mkdir -m 0755 -p /dev/pts
[ -e /proc/bus/usb ] && mount -t usbfs none /proc/bus/usb # UML doesn't have USB by default
mkdir -m 01777 -p /tmp
mkdir -m 0755 -p /var /var/log
mkdir -m 0755 -p /nix/var
mkdir -m 0700 -p /root
mkdir -m 0755 -p /bin # for the /bin/sh symlink
mkdir -m 0755 -p /home
mkdir -m 0755 -p /etc/nixos
mkdir -m 0700 -p /var/log/journal


# Miscellaneous boot time cleanup.
rm -rf /var/run /var/lock
rm -f /etc/resolv.conf

if test -n "@cleanTmpDir@"; then
    echo -n "cleaning \`/tmp'..."
    find /tmp -maxdepth 1 -mindepth 1 -print0 | xargs -0r rm -rf --one-file-system
    echo " done"
else
    # Get rid of ICE locks...
    rm -rf /tmp/.ICE-unix
fi

# ... and ensure that it's owned by root.
mkdir -m 1777 /tmp/.ICE-unix

# This is a good time to clean up /nix/var/nix/chroots.  Doing an `rm
# -rf' on it isn't safe in general because it can contain bind mounts
# to /nix/store and other places.  But after rebooting these are all
# gone, of course.
rm -rf /nix/var/nix/chroots # recreated in activate-configuration.sh


# Also get rid of temporary GC roots.
rm -rf /nix/var/nix/gcroots/tmp /nix/var/nix/temproots


# Create a tmpfs on /run to hold runtime state for programs such as
# udev (if stage 1 hasn't already done so).
if ! mountpoint -q /run; then
    rm -rf /run
    mkdir -m 0755 -p /run
    mount -t tmpfs -o "mode=0755,size=@runSize@" none /run
fi

mkdir -m 0755 -p /run/lock


# For backwards compatibility, symlink /var/run to /run, and /var/lock
# to /run/lock.
ln -s /run /var/run
ln -s /run/lock /var/lock


# Clear the resume device.
if test -n "$resumeDevice"; then
    mkswap "$resumeDevice" || echo 'Failed to clear saved image.'
fi


# Run the script that performs all configuration activation that does
# not have to be done at boot time.
echo "running activation script..."
$systemConfig/activate


# Record the boot configuration.
ln -sfn "$systemConfig" /run/booted-system

# Prevent the booted system form being garbage-collected If it weren't
# a gcroot, if we were running a different kernel, switched system,
# and garbage collected all, we could not load kernel modules anymore.
ln -sfn /run/booted-system /nix/var/nix/gcroots/booted-system


# Run any user-specified commands.
@shell@ @postBootCommands@


# Start systemd.
echo "starting systemd..."
PATH=/run/current-system/systemd/lib/systemd \
    MODULE_DIR=/run/booted-system/kernel-modules/lib/modules \
    LOCALE_ARCHIVE=/run/current-system/sw/lib/locale/locale-archive \
    exec systemd --log-target=journal # --log-level=debug --log-target=console --crash-shell
