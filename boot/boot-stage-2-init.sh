#! @shell@

# !!! copied from stage 1; remove duplication


# Print a greeting.
echo
echo "<<< NixOS Stage 2 >>>"
echo


# Set the PATH.
export PATH=/empty
for i in @startPath@; do
    PATH=$PATH:$i/bin
    if test -e $i/sbin; then
        PATH=$PATH:$i/sbin
    fi
done


# Mount special file systems.

needWritableDir() {
    if test -n "@readOnlyRoot@"; then
        mount -t tmpfs -o "mode=$2" none $1 $3
    else
        mkdir -m $2 -p $1
    fi
}

needWritableDir /etc 0755 -n # to shut up mount

test -e /etc/fstab || touch /etc/fstab # idem

mount -n -t proc none /proc
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
    esac
done


# More special file systems, initialise required directories.
mount -t sysfs none /sys
mount -t tmpfs -o "mode=0755" none /dev
needWritableDir /tmp 01777
needWritableDir /var 0755
needWritableDir /nix/var 0755


# Miscellaneous boot time cleanup.
rm -rf /var/run


# Create the minimal device nodes needed before we run udev.
mknod -m 0666 /dev/null c 1 3


# Run the script that performs all configuration activation that does
# not have to be done at boot time.
@activateConfiguration@


# Ensure that the module tools can find the kernel modules.
export MODULE_DIR=@kernel@/lib/modules/


# Start udev.
udevd --daemon


# Let udev create device nodes for all modules that have already been
# loaded into the kernel (or for which support is built into the
# kernel).
udevtrigger
udevsettle # wait for udev to finish


# Start an interactive shell.
#exec @shell@


# Start Upstart's init.
export UPSTART_CFG_DIR=/etc/event.d
export PATH=/empty
for i in @upstartPath@; do PATH=$PATH:$i/bin; done
exec @upstart@/sbin/init -v
