#! @shell@

targetRoot=/mnt-root

export LD_LIBRARY_PATH=@extraUtils@/lib
export PATH=@extraUtils@/bin


fail() {
    if [ -n "$panicOnFail" ]; then exit 1; fi
    
    # If starting stage 2 failed, allow the user to repair the problem
    # in an interactive shell.
    cat <<EOF

An error occured in stage 1 of the boot process, which must mount the
root filesystem on \`$targetRoot' and then start stage 2.  Press one
of the following keys:

  i) to launch an interactive shell;
  f) to start an interactive shell having pid 1 (needed if you want to
     start stage 2's init manually); or
  *) to ignore the error and continue.
EOF

    read reply
    
    case $reply in
        f)
            exec @shell@;;
        i)
            echo "Starting interactive shell..."
            @shell@ || fail
            ;;
        *)
            echo "Continuing...";;
    esac
}

trap 'fail' ERR


# Print a greeting.
echo
echo "[1;32m<<< NixOS Stage 1 >>>[0m"
echo


# Mount special file systems.
mkdir -p /etc # to shut up mount
echo -n > /etc/fstab # idem
mkdir -p /proc
mount -t proc none /proc
mkdir -p /sys
mount -t sysfs none /sys
mount -t tmpfs -o "mode=0755,size=@devSize@" none /dev


# Process the kernel command line.
export stage2Init=/init
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
        debug1) # stop right away
            fail
            ;;
        debug1devices) # stop after loading modules and creating device nodes
            debug1devices=1
            ;;
        debug1mounts) # stop after mounting file systems
            debug1mounts=1
            ;;
        stage1panic)
            panicOnFail=1
            ;;
    esac
done


# Load the required kernel modules.
echo @extraUtils@/bin/modprobe > /proc/sys/kernel/modprobe
for i in @kernelModules@; do
    echo "loading module $(basename $i)..."
    modprobe $i || true
done


# Create /dev/null.
mknod /dev/null c 1 3


# Try to resume - all modules are loaded now.
if test -e /sys/power/tuxonice/resume; then
    if test -n "$(cat /sys/power/tuxonice/resume)"; then
        echo 0 > /sys/power/tuxonice/user_interface/enabled
        echo 1 > /sys/power/tuxonice/do_resume || echo "failed to resume..."
    fi
fi

if test -e /sys/power/resume -a -e /sys/power/disk; then
    echo "@resumeDevice@" > /sys/power/resume 2> /dev/null || echo "failed to resume..."
    echo shutdown > /sys/power/disk
fi


# Create device nodes in /dev.
echo "running udev..."
export UDEV_CONFIG_FILE=@udevConf@
mkdir -p /dev/.udev # !!! bug in udev?
mkdir -p /dev/.mdadm
udevd --daemon
udevadm control --env=STARTUP=1
udevadm trigger --action=add
udevadm settle
udevadm control --env=STARTUP=

echo "starting device mapper and LVM..."
lvm vgscan
lvm vgchange -ay
                                                                        
if test -n "$debug1devices"; then fail; fi


@postDeviceCommands@


# Return true if the machine is on AC power, or if we can't determine
# whether it's on AC power.
onACPower() {
    ! test -d "/proc/acpi/battery" ||
    ! ls /proc/acpi/battery/BAT[0-9]* > /dev/null 2>&1 ||
    ! cat /proc/acpi/battery/BAT*/state | grep "^charging state" | grep -q "discharg"
}


# Check the specified file system, if appropriate.
checkFS() {
    # Only check block devices.
    if ! test -b "$device"; then return 0; fi

    FSTYPE=$(blkid -o value -s TYPE "$device" || true)

    # Don't check ROM filesystems.
    if test "$FSTYPE" = iso9660 -o "$FSTYPE" = udf; then return 0; fi

    # Optionally, skip fsck on journaling filesystems.  This option is
    # a hack - it's mostly because e2fsck on ext3 takes much longer to
    # recover the journal than the ext3 implementation in the kernel
    # does (minutes versus seconds).
    if test -z "@checkJournalingFS@" -a \
        \( "$FSTYPE" = ext3 -o "$FSTYPE" = ext4 -o "$FSTYPE" = reiserfs \
        -o "$FSTYPE" = xfs -o "$FSTYPE" = jfs \)
    then
        return 0
    fi
    
    # Don't run `fsck' if the machine is on battery power.  !!! Is
    # this a good idea?
    if ! onACPower; then
        echo "on battery power, so no \`fsck' will be performed on \`$device'"
        return 0
    fi

    FSTAB_FILE="/etc/mtab" fsck -V -C -a "$device"
    fsckResult=$?

    if test $(($fsckResult | 2)) = $fsckResult; then
        echo "fsck finished, rebooting..."
        sleep 3
        reboot
    fi

    if test $(($fsckResult | 4)) = $fsckResult; then
        echo "$device has unrepaired errors, please fix them manually."
        fail
    fi

    if test $fsckResult -ge 8; then
        echo "fsck on $device failed."
        fail
    fi

    return 0
}


# Function for mounting a file system.
mountFS() {
    local device="$1"
    local mountPoint="$2"
    local options="$3"
    local fsType="$4"

    checkFS "$device"

    mkdir -p "/mnt-root$mountPoint" || true

    # For CIFS mounts, retry a few times before giving up.
    local n=0
    while true; do
        if mount -t "$fsType" -o "$options" "$device" /mnt-root$mountPoint; then
            break
        fi
        if [ "$fsType" != cifs -o "$n" -ge 10 ]; then fail; break; fi
        echo "retrying..."
        n=$((n + 1))
    done
}


# Try to find and mount the root device.
mkdir /mnt-root

mountPoints=(@mountPoints@)
devices=(@devices@)
fsTypes=(@fsTypes@)
optionss=(@optionss@)

for ((n = 0; n < ${#mountPoints[*]}; n++)); do
    mountPoint=${mountPoints[$n]}
    device=${devices[$n]}
    fsType=${fsTypes[$n]}
    options=${optionss[$n]}

    # !!! Really quick hack to support bind mounts, i.e., where the
    # "device" should be taken relative to /mnt-root, not /.  Assume
    # that every device that starts with / but doesn't start with /dev
    # is a bind mount.
    pseudoDevice=
    case $device in
        /dev/*)
            ;;
        //*)
            # Don't touch SMB/CIFS paths.
            pseudoDevice=1
            ;;
        /*)
            device=/mnt-root$device
            ;;
        *)
            # Not an absolute path; assume that it's a pseudo-device
            # like an NFS path (e.g. "server:/path").
            pseudoDevice=1
            ;;
    esac

    # USB storage devices tend to appear with some delay.  It would be
    # great if we had a way to synchronously wait for them, but
    # alas...  So just wait for a few seconds for the device to
    # appear.  If it doesn't appear, try to mount it anyway (and
    # probably fail).  This is a fallback for non-device "devices"
    # that we don't properly recognise.
    if test -z "$pseudoDevice" -a ! -e $device; then
        echo -n "waiting for device $device to appear..."
        for ((try = 0; try < 10; try++)); do
            sleep 1
            if test -e $device; then break; fi
            echo -n "."
        done
        echo
    fi

    echo "mounting $device on $mountPoint..."

    mountFS "$device" "$mountPoint" "$options" "$fsType"
done


@postMountCommands@


# Stop udevd.
kill -- -1


if test -n "$debug1mounts"; then fail; fi


# Restore /proc/sys/kernel/modprobe to its original value.
echo /sbin/modprobe > /proc/sys/kernel/modprobe


# Start stage 2.  `switch_root' deletes all files in the ramfs on the
# current root.  It also moves the /proc, /sys and /dev mounts over to
# the new root.  Note that $stage2Init might be an absolute symlink,
# in which case "-e" won't work because we're not in the chroot yet.
if ! test -e "$targetRoot/$stage2Init" -o -L "$targetRoot/$stage2Init"; then
    echo "stage 2 init script ($targetRoot/$stage2Init) not found"
    fail
fi

mkdir -m 0755 -p $targetRoot/proc $targetRoot/sys $targetRoot/dev

exec switch_root "$targetRoot" "$stage2Init"

fail # should never be reached
