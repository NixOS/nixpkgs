#! @staticShell@

targetRoot=/mnt/root
dialog(){
    timeout=15
    echo
    echo "Press within $timeout seconds:"
    echo "  f) to switch finally to an interactive shell having pid 1"
    echo "     (you'll need this to start stage2 / upstart)"
    echo "  i) to launch an intercative shell"
    echo "  *) to continue immediately (ignoring the failing command)"
    read -t $timeout reply
    case $reply in
      f) exec @staticShell@;;
      i) echo
         echo "Quit interactive shell with exit status of"
         echo " 0        : to continue"
         echo " non zero : to get this dialog again (eg to switch to interactive shell with pid 1"
        @staticShell@ || fail
      ;;
      *) echo continuing ignoring error;;
    esac
}

fail(){
    # If starting stage 2 failed, start an interactive shell.
    echo "error while running Stage 1"
    echo "Stage 1 should mount the root partition containing the nix store on \`$targetRoot'";
    echo
    dialog
}
trap 'fail' ERR;



# Poor man's `basename'.
basename() {
    local s="$1"
    set -- $(IFS=/; echo $s)
    local res
    while test $# != 0; do res=$1; shift; done
    echo $res
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
echo -n > /etc/fstab # idem
mkdir -p /proc
mount -t proc none /proc
mkdir -p /sys
mount -t sysfs none /sys


# Process the kernel command line.
stage2Init=/init
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
    esac
done


# Load some kernel modules.
for i in $(cat @modulesClosure@/insmod-list); do
    echo "loading module $(basename $i)..."
    insmod $i
done


# Create /dev/null.
mknod /dev/null c 1 3


# Try to resume - all modules are loaded now.
if test -e /sys/power/tuxonice/resume; then
    if test -n "$(cat /sys/power/tuxonice/resume)"; then
        echo 0 > /sys/power/tuxonice/user_interface/enabled
        echo 1 > /sys/power/tuxonice/do_resume || echo "Failed to resume..."
    fi
fi

echo "@resumeDevice@" > /sys/power/resume 2> /dev/null || echo "Failed to resume..."
echo shutdown > /sys/power/disk


# Create device nodes in /dev.
export UDEV_CONFIG_FILE=@udevConf@
udevd --daemon
udevadm trigger
udevadm settle

if type -p dmsetup > /dev/null; then
  echo "dmsetup found, starting device mapper and lvm"
  dmsetup mknodes
  lvm vgscan --ignorelockingfailure
  lvm vgchange -ay --ignorelockingfailure
fi

if test -n "$debug1devices"; then fail; fi


# Function for mounting a file system.
mountFS() {
    local device="$1"
    local mountPoint="$2"
    local options="$3"
    local fsType="$4"

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
        FSTAB_FILE="/etc/mtab" fsck -V -v -C -a "$device"
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
    fi

    # Mount read-writable.
    mount -t "$fsType" -o "$options" "$device" /mnt-root$mountPoint || fail
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
    # that every device that start with / but doesn't start with /dev
    # or LABEL= is a bind mount.
    case $device in
        /dev/*)
            ;;
        /*)
            device=/mnt-root$device
            ;;
    esac

    # USB storage devices tend to appear with some delay.  It would be
    # great if we had a way to synchronously wait for them, but
    # alas...  So just wait for a few seconds for the device to
    # appear.  If it doesn't appear, try to mount it anyway (and
    # probably fail).  This is a fallback for non-device "devices"
    # that we don't properly recognise (like NFS mounts).
    if ! test -e $device; then
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


# If this is a live-CD/DVD, then union-mount a tmpfs on top of the
# original root.
targetRoot=/mnt-root
if test -n "@isLiveCD@"; then
    mkdir /mnt-tmpfs
    mount -t tmpfs -o "mode=755" none /mnt-tmpfs
    mkdir /mnt-union
    mount -t aufs -o dirs=/mnt-tmpfs=rw:$targetRoot=ro none /mnt-union
    targetRoot=/mnt-union
fi


# Stop udevd.
kill $(minips -C udevd -o pid=)


if test -n "$debug1mounts"; then fail; fi


# `run-init' needs a /dev/console on the target FS.
if ! test -e $targetRoot/dev/console; then
    mkdir -p $targetRoot/dev
    mknod $targetRoot/dev/console c 5 1
fi


# Start stage 2.  `run-init' deletes all files in the ramfs on the
# current /.
if test -z "$stage2Init"; then fail; fi
umount /sys
umount /proc
exec run-init "$targetRoot" "$stage2Init"

echo
echo $1 failed running "$stage2Init"
echo "It's your last chance to fix things manually without rebooting"
echo "finally switching to interactive shell pid 1"
export $stage2Init; exec @staticShell@
