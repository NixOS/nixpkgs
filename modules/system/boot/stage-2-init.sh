#! @shell@

# !!! copied from stage 1; remove duplication


# Print a greeting.
echo
echo "<<< NixOS Stage 2 >>>"
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


# Mount special file systems.
mkdir -m 0755 -p /etc
test -e /etc/fstab || touch /etc/fstab # to shut up mount
[ -s /etc/mtab ] && rm /etc/mtab # while installing a symlink is created (see man mount), if it's still there for whateever reason remove it
rm -f /etc/mtab* # not that we care about stale locks
mkdir -m 0755 -p /proc
mount -n -t proc none /proc

rm -f /etc/mtab
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
        systemConfig=*)
            set -- $(IFS==; echo $o)
            systemConfig=$2
            ;;
        resume=*)
            set -- $(IFS==; echo $o)
            resumeDevice=$2
            ;;
    esac
done


# More special file systems, initialise required directories.
mkdir -m 0755 -p /sys 
mount -t sysfs none /sys
mkdir -m 0755 -p /dev
mount -t tmpfs -o "mode=0755" none /dev
mkdir -m 0777 /dev/shm
mount -t tmpfs -o "rw,nosuid,nodev" tmpfs /dev/shm
mkdir -m 0755 -p /dev/pts
mount -t devpts -o mode=0600 none /dev/pts 
[ -e /proc/bus/usb ] && mount -t usbfs none /proc/bus/usb # uml doesn't have usb by default
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

#echo -n "cleaning \`/tmp'..."
#rm -rf --one-file-system /tmp/*
#echo " done"


# This is a good time to clean up /nix/var/nix/chroots.  Doing an `rm
# -rf' on it isn't safe in general because it can contain bind mounts
# to /nix/store and other places.  But after rebooting these are all
# gone, of course.
rm -rf /nix/var/nix/chroots # recreated in activate-configuration.sh

if test -n "$safeMode"; then
    mkdir -m 0755 -p /var/run
    touch /var/run/safemode
fi


# Create the minimal device nodes needed before we run udev.
mknod -m 0666 /dev/null c 1 3
mknod -m 0644 /dev/urandom c 1 9 # needed for passwd


# Clear the resume device.
if test -n "$resumeDevice"; then
    mkswap "$resumeDevice" || echo 'Failed to clear saved image.'
fi

echo "running activation script..."

# Run the script that performs all configuration activation that does
# not have to be done at boot time.
@activateConfiguration@ "$systemConfig"


# Record the boot configuration.  !!! Should this be a GC root?
if test -n "$systemConfig"; then
    ln -sfn "$systemConfig" /var/run/booted-system
fi


# Ensure that the module tools can find the kernel modules.
export MODULE_DIR=@kernel@/lib/modules/

echo "Running post-boot commands"

# Run any user-specified commands.
@shell@ @postBootCommands@

echo "starting Upstart..."

# Start Upstart's init.  We start it through the
# /var/run/current-system symlink indirection so that we can upgrade
# init in a running system by changing the symlink and sending init a
# HUP signal.
export UPSTART_CFG_DIR=/etc/event.d
setPath "@upstartPath@"
exec /var/run/current-system/upstart/sbin/init
