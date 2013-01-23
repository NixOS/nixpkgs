#! @shell@

targetRoot=/mnt-root
console=tty1

export LD_LIBRARY_PATH=@extraUtils@/lib
export PATH=@extraUtils@/bin:@extraUtils@/sbin


fail() {
    if [ -n "$panicOnFail" ]; then exit 1; fi

    # If starting stage 2 failed, allow the user to repair the problem
    # in an interactive shell.
    cat <<EOF

An error occured in stage 1 of the boot process, which must mount the
root filesystem on \`$targetRoot' and then start stage 2.  Press one
of the following keys:

EOF
    if [ -n "$allowShell" ]; then cat <<EOF
  i) to launch an interactive shell
  f) to start an interactive shell having pid 1 (needed if you want to
     start stage 2's init manually)
EOF
    fi
    cat <<EOF
  r) to reboot immediately
  *) to ignore the error and continue
EOF

    read reply

    if [ -n "$allowShell" -a "$reply" = f ]; then
        exec setsid @shell@ -c "@shell@ < /dev/$console >/dev/$console 2>/dev/$console"
    elif [ -n "$allowShell" -a "$reply" = i ]; then
        echo "Starting interactive shell..."
        setsid @shell@ -c "@shell@ < /dev/$console >/dev/$console 2>/dev/$console" || fail
    elif [ "$reply" = r ]; then
        echo "Rebooting..."
        reboot -f
    else
        echo "Continuing..."
    fi
}

trap 'fail' 0


# Print a greeting.
echo
echo "[1;32m<<< NixOS Stage 1 >>>[0m"
echo


# Mount special file systems.
mkdir -p /etc
touch /etc/fstab # to shut up mount
touch /etc/mtab # to shut up mke2fs
mkdir -p /proc
mount -t proc none /proc
mkdir -p /sys
mount -t sysfs none /sys
mount -t devtmpfs -o "size=@devSize@" none /dev
mkdir -p /run
mount -t tmpfs -o "mode=0755,size=@runSize@" none /run
mount -t securityfs none /sys/kernel/security

# Process the kernel command line.
export stage2Init=/init
for o in $(cat /proc/cmdline); do
    case $o in
        console=*)
            set -- $(IFS==; echo $o)
            params=$2
            set -- $(IFS=,; echo $params)
            console=$1
            ;;
        init=*)
            set -- $(IFS==; echo $o)
            stage2Init=$2
            ;;
        boot.trace|debugtrace)
            # Show each command.
            set -x
            ;;
        boot.shell_on_fail)
            allowShell=1
            ;;
        boot.debug1|debug1) # stop right away
            allowShell=1
            fail
            ;;
        boot.debug1devices) # stop after loading modules and creating device nodes
            allowShell=1
            debug1devices=1
            ;;
        boot.debug1mounts) # stop after mounting file systems
            allowShell=1
            debug1mounts=1
            ;;
        boot.panic_on_fail|stage1panic=1)
            panicOnFail=1
            ;;
        root=*)
            # If a root device is specified on the kernel command
            # line, make it available through the symlink /dev/root.
            # Recognise LABEL= and UUID= to support UNetbootin.
            set -- $(IFS==; echo $o)
            if [ $2 = "LABEL" ]; then
                root="/dev/disk/by-label/$3"
            elif [ $2 = "UUID" ]; then
                root="/dev/disk/by-uuid/$3"
            else
                root=$2
            fi
            ln -s "$root" /dev/root
            ;;
    esac
done


# Load the required kernel modules.
mkdir -p /lib
ln -s @modulesClosure@/lib/modules /lib/modules
echo @extraUtils@/bin/modprobe > /proc/sys/kernel/modprobe
for i in @kernelModules@; do
    echo "loading module $(basename $i)..."
    modprobe $i || true
done


# Create device nodes in /dev.
echo "running udev..."
mkdir -p /etc/udev
ln -sfn @udevRules@ /etc/udev/rules.d
mkdir -p /dev/.mdadm
systemd-udevd --daemon
udevadm trigger --action=add
udevadm settle || true
modprobe scsi_wait_scan || true
udevadm settle || true


# Load boot-time keymap before any LVM/LUKS initialization
@extraUtils@/bin/busybox loadkmap < "@busyboxKeymap@"


# XXX: Use case usb->lvm will still fail, usb->luks->lvm is covered
@preLVMCommands@


echo "starting device mapper and LVM..."
lvm vgchange -ay

if test -n "$debug1devices"; then fail; fi


@postDeviceCommands@


# Try to resume - all modules are loaded now, and devices exist
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


# Return true if the machine is on AC power, or if we can't determine
# whether it's on AC power.
onACPower() {
    ! test -d "/proc/acpi/battery" ||
    ! ls /proc/acpi/battery/BAT[0-9]* > /dev/null 2>&1 ||
    ! cat /proc/acpi/battery/BAT*/state | grep "^charging state" | grep -q "discharg"
}


# Check the specified file system, if appropriate.
checkFS() {
    local device="$1"
    local fsType="$2"

    # Only check block devices.
    if [ ! -b "$device" ]; then return 0; fi

    # Don't check ROM filesystems.
    if [ "$fsType" = iso9660 -o "$fsType" = udf ]; then return 0; fi

    # If we couldn't figure out the FS type, then skip fsck.
    if [ "$fsType" = auto ]; then
        echo 'cannot check filesystem with type "auto"!'
        return 0
    fi

    # Optionally, skip fsck on journaling filesystems.  This option is
    # a hack - it's mostly because e2fsck on ext3 takes much longer to
    # recover the journal than the ext3 implementation in the kernel
    # does (minutes versus seconds).
    if test -z "@checkJournalingFS@" -a \
        \( "$fsType" = ext3 -o "$fsType" = ext4 -o "$fsType" = reiserfs \
        -o "$fsType" = xfs -o "$fsType" = jfs \)
    then
        return 0
    fi

    # Don't run `fsck' if the machine is on battery power.  !!! Is
    # this a good idea?
    if ! onACPower; then
        echo "on battery power, so no \`fsck' will be performed on \`$device'"
        return 0
    fi

    echo "checking $device..."

    fsck -V -a "$device"
    fsckResult=$?

    if test $(($fsckResult | 2)) = $fsckResult; then
        echo "fsck finished, rebooting..."
        sleep 3
        reboot -f
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

    if [ "$fsType" = auto ]; then
        fsType=$(blkid -o value -s TYPE "$device")
        if [ -z "$fsType" ]; then fsType=auto; fi
    fi

    echo "$device /mnt-root$mountPoint $fsType $options" >> /etc/fstab

    checkFS "$device" "$fsType"

    echo "mounting $device on $mountPoint..."

    mkdir -p "/mnt-root$mountPoint" || true

    # For CIFS mounts, retry a few times before giving up.
    local n=0
    while true; do
        mount "/mnt-root$mountPoint" && break
        if [ "$fsType" != cifs -o "$n" -ge 10 ]; then fail; break; fi
        echo "retrying..."
        n=$((n + 1))
    done
}


# Try to find and mount the root device.
mkdir /mnt-root

exec 3< @fsInfo@

while read -u 3 mountPoint; do
    read -u 3 device
    read -u 3 fsType
    read -u 3 options

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
        for try in $(seq 1 20); do
            sleep 1
            if test -e $device; then break; fi
            echo -n "."
        done
        echo
    fi

    # Wait once more for the udev queue to empty, just in case it's
    # doing something with $device right now.
    udevadm settle || true

    mountFS "$device" "$mountPoint" "$options" "$fsType"
done

exec 3>&-


@postMountCommands@


# Stop udevd.
udevadm control --exit || true

# Kill any remaining processes, just to be sure we're not taking any
# with us into stage 2. unionfs-fuse mounts require the unionfs process.
pkill -9 -v '(1|unionfs)'


if test -n "$debug1mounts"; then fail; fi


# Restore /proc/sys/kernel/modprobe to its original value.
echo /sbin/modprobe > /proc/sys/kernel/modprobe


# Start stage 2.  `switch_root' deletes all files in the ramfs on the
# current root.  Note that $stage2Init might be an absolute symlink,
# in which case "-e" won't work because we're not in the chroot yet.
if ! test -e "$targetRoot/$stage2Init" -o -L "$targetRoot/$stage2Init"; then
    echo "stage 2 init script ($targetRoot/$stage2Init) not found"
    fail
fi

mkdir -m 0755 -p $targetRoot/proc $targetRoot/sys $targetRoot/dev $targetRoot/run

mount --move /proc $targetRoot/proc
mount --move /sys $targetRoot/sys
mount --move /dev $targetRoot/dev
mount --move /run $targetRoot/run

exec env -i $(type -P switch_root) "$targetRoot" "$stage2Init"

fail # should never be reached
