#! @shell@

systemConfig=@systemConfig@


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
# However, in some environments (such as Amazon EC2), stage 2 is
# executed directly, and the root is read-only.  So make it writable
# here.
mount -n -o remount,rw none /


# Likewise, stage 1 mounts /proc, /dev and /sys, so if we don't have a
# stage 1, we need to do that here.
if [ ! -e /proc/1 ]; then
    mkdir -m 0755 -p /proc
    mount -n -t proc none /proc
    mkdir -m 0755 -p /sys 
    mount -t sysfs none /sys
    mkdir -m 0755 -p /dev
    mount -t tmpfs -o "mode=0755" none /dev

    # Create the minimal device nodes needed for the activation scripts
    # and Upstart.
    mknod -m 0666 /dev/null c 1 3
    mknod -m 0644 /dev/urandom c 1 9 # needed for passwd
    mknod -m 0644 /dev/console c 5 1
fi


# Provide a /etc/mtab.
mkdir -m 0755 -p /etc
test -e /etc/fstab || touch /etc/fstab # to shut up mount
rm -f /etc/mtab* # not that we care about stale locks
cat /proc/mounts > /etc/mtab


# Process the kernel command line.
for o in $(cat /proc/cmdline); do
    case $o in
        debugtrace)
            # Show each command.
            set -x
            ;;
        debug2)
            echo "Debug shell called from @out@"
            exec @shell@
            ;;
        S|s|single)
            # !!! argh, can't pass a startup event to Upstart yet.
            exec @shell@
            ;;
        safemode)
            safeMode=1
            ;;
        resume=*)
            set -- $(IFS==; echo $o)
            resumeDevice=$2
            ;;
    esac
done


# More special file systems, initialise required directories.
mkdir -m 0777 /dev/shm
mount -t tmpfs -o "rw,nosuid,nodev,size=@devShmSize@" tmpfs /dev/shm
mkdir -m 0755 -p /dev/pts
mount -t devpts -o mode=0600,gid=@ttyGid@ none /dev/pts 
[ -e /proc/bus/usb ] && mount -t usbfs none /proc/bus/usb # UML doesn't have USB by default
mkdir -m 01777 -p /tmp 
mkdir -m 0755 -p /var
mkdir -m 0755 -p /nix/var
mkdir -m 0700 -p /root
mkdir -m 0755 -p /bin # for the /bin/sh symlink
mkdir -m 0755 -p /home
mkdir -m 0755 -p /etc/nixos


# Miscellaneous boot time cleanup.
rm -rf /var/run
rm -rf /var/lock
rm -rf /var/log/upstart

#echo -n "cleaning \`/tmp'..."
#rm -rf --one-file-system /tmp/*
#echo " done"


# Get rid of ICE locks and ensure that it's owned by root.
rm -rf /tmp/.ICE-unix
mkdir -m 1777 /tmp/.ICE-unix


# This is a good time to clean up /nix/var/nix/chroots.  Doing an `rm
# -rf' on it isn't safe in general because it can contain bind mounts
# to /nix/store and other places.  But after rebooting these are all
# gone, of course.
rm -rf /nix/var/nix/chroots # recreated in activate-configuration.sh


# Also get rid of temporary GC roots.
rm -rf /nix/var/nix/gcroots/tmp /nix/var/nix/temproots


# Use a tmpfs for /var/run to ensure that / or /var can be unmounted
# or at least remounted read-only during shutdown.  (Upstart 0.6
# apparently uses nscd to do some name lookups, resulting in it
# holding some mmap mapping to deleted files in /var/run/nscd.
# Similarly, portmap and statd have open files in /var/run and are
# needed during shutdown to unmount NFS volumes.)
mkdir -m 0755 -p /var/run
mount -t tmpfs -o "mode=755" none /var/run


# Clear the resume device.
if test -n "$resumeDevice"; then
    mkswap "$resumeDevice" || echo 'Failed to clear saved image.'
fi


# Run the script that performs all configuration activation that does
# not have to be done at boot time.
echo "running activation script..."
$systemConfig/activate


# Record the boot configuration.
ln -sfn "$systemConfig" /var/run/booted-system

# Prevent the booted system form being garbage-collected If it weren't
# a gcroot, if we were running a different kernel, switched system,
# and garbage collected all, we could not load kernel modules anymore.
ln -sfn /var/run/booted-system /nix/var/nix/gcroots/booted-system


# Ensure that the module tools can find the kernel modules.
export MODULE_DIR=@kernel@/lib/modules/


# Run any user-specified commands.
@shell@ @postBootCommands@


# For debugging Upstart.
#@shell@ --login < /dev/console > /dev/console 2>&1 &


# Start Upstart's init.
echo "starting Upstart..."
PATH=/var/run/current-system/upstart/sbin exec init
