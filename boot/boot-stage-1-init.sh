#! @staticShell@

fail() {
    # If starting stage 2 failed, start an interactive shell.
    echo "Stage 2 failed, starting emergency shell..."
    echo "(Stage 1 init script is $stage2Init)"
    exec @staticShell@
}


# Print a greeting.
echo
echo "<<< NixOS Stage 1 >>>"
echo


# Set the PATH.
export PATH=/empty
for i in @path@; do
    PATH=$PATH:$i/bin
    if test -e $i/sbin; then
        PATH=$PATH:$i/sbin
    fi
done


# Mount special file systems.
mkdir -p /etc # to shut up mount
touch /etc/fstab # idem
mkdir -p /proc
mount -t proc none /proc
mkdir -p /sys
mount -t sysfs none /sys


# Process the kernel command line.
stage2Init=@stage2Init@
for o in $(cat /proc/cmdline); do
    case $o in
        init=*)
            set -- $(IFS==; echo $o)
            stage2Init=$2
            ;;
        debugtrace)
            # Show each command.
            set -x
            ;;
        debug1)
            fail
            ;;
    esac
done


# Load some kernel modules.
export MODULE_DIR=@modulesDir@/lib/modules/
for i in @modules@; do
    modprobe $i
done


# Create device nodes in /dev.
mknod -m 0666 /dev/null c 1 3
export UDEV_CONFIG_FILE=/udev.conf
echo 'udev_rules="/no-rules"' > $UDEV_CONFIG_FILE
udevd --daemon
udevtrigger
udevsettle


# Function for mounting a file system.
mountFS() {
    local device="$1"
    local mountPoint="$2"
    local options="$3"

    # Check the root device, if .
    mustCheck=
    if test -b "$device"; then
        mustCheck=1
    else
        case $device in
            LABEL=*)
                mustCheck=1
                ;;
        esac
    fi

    if test -n "$mustCheck"; then
        fsck -C -a "$device"
        fsckResult=$?

        if test $(($fsckResult | 2)) = $fsckResult; then
            echo "fsck finished, rebooting..."
            sleep 3
            # reboot -f -d !!! don't have reboot yet
            fail
        fi

        if test $(($fsckResult | 4)) = $fsckResult; then
            echo "$device has unrepaired errors, please fix them manually."
            fail
        fi

        if test $fsckResult -ge 8; then
            echo "fsck on $device failed."
            fail
        fi
    fi

    # Mount read-writable.
    mount -n -o "$options" "$device" /mnt/root$mountPoint || fail
}


# Try to find and mount the root device.
mkdir /mnt
mkdir /mnt/root

echo "mounting the root device.... (fix: sleeping 5 seconds to wait for upcoming usb drivers)"
sleep 5

if test -n "@autoDetectRootDevice@"; then

    # Look for the root device by label.
    echo "probing for the NixOS installation CD..."

    for i in /sys/block/*; do
        if test "$(cat $i/removable)" = "1"; then

            echo "  in $(basename $i)..."

            set -- $(IFS=: ; echo $(cat $i/dev))
            major="$1"
            minor="$2"

            # Create a device node for this device.
            rm -f /dev/tmpdev
            mknod /dev/tmpdev b "$major" "$minor"

            if mount -n -o ro -t iso9660 /dev/tmpdev /mnt/root; then
                if test -e "/mnt/root/@rootLabel@"; then
                    found=1
                    break
                fi
                umount /mnt/root
            fi
        
        fi
    done

    if test -z "$found"; then
        echo "CD not found!"
        fail
    fi

else

    # Hard-coded root device(s).
    mountPoints=(@mountPoints@)
    devices=(@devices@)
    fsTypes=(@fsTypes@)
    optionss=(@optionss@)

    for ((n = 0; n < ${#mountPoints[*]}; n++)); do
        mountPoint=${mountPoints[$n]}
        device=${devices[$n]}
        fsType=${fsTypes[$n]}
        options=${optionss[$n]}

        # !!! Really quick hack to support bind mounts, i.e., where
        # the "device" should be taken relative to /mnt/root, not /.
        # Assume that every device that doesn't start with /dev or
        # LABEL= is a bind mount.
        case $device in
            /dev/*)
                ;;
            LABEL=*)
                ;;
            *)
                device=/mnt/root$device
                ;;
        esac

        echo "mounting $device on $mountPoint..."

        mountFS "$device" "$mountPoint" "$options"
    done
    
fi


# Start stage 2.
# !!! Note: we can't use pivot_root here (the kernel gods have
# decreed), but we could use run-init from klibc, which deletes all
# files in the initramfs, remounts the target root on /, and chroots.
cd /mnt/root
mount --move . /
umount /proc # cleanup
umount /sys

if test -z "$stage2Init"; then fail; fi

exec chroot . $stage2Init

fail
