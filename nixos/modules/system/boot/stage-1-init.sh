#! @shell@

targetRoot=/mnt-root
console=tty1
verbose="@verbose@"

info() {
    if [[ -n "$verbose" ]]; then
        echo "$@"
    fi
}

extraUtils="@extraUtils@"
export LD_LIBRARY_PATH=@extraUtils@/lib
export PATH=@extraUtils@/bin
ln -s @extraUtils@/bin /bin
# hardcoded in util-linux's mount helper search path `/run/wrappers/bin:/run/current-system/sw/bin:/sbin`
ln -s @extraUtils@/bin /sbin

# Copy the secrets to their needed location
if [ -d "@extraUtils@/secrets" ]; then
    for secret in $(cd "@extraUtils@/secrets"; find . -type f); do
        mkdir -p $(dirname "/$secret")
        ln -s "@extraUtils@/secrets/$secret" "$secret"
    done
fi

# Stop LVM complaining about fd3
export LVM_SUPPRESS_FD_WARNINGS=true

fail() {
    if [ -n "$panicOnFail" ]; then exit 1; fi

    @preFailCommands@

    # If starting stage 2 failed, allow the user to repair the problem
    # in an interactive shell.
    cat <<EOF

An error occurred in stage 1 of the boot process, which must mount the
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

    read -n 1 reply

    if [ -n "$allowShell" -a "$reply" = f ]; then
        exec setsid @shell@ -c "exec @shell@ < /dev/$console >/dev/$console 2>/dev/$console"
    elif [ -n "$allowShell" -a "$reply" = i ]; then
        echo "Starting interactive shell..."
        setsid @shell@ -c "exec @shell@ < /dev/$console >/dev/$console 2>/dev/$console" || fail
    elif [ "$reply" = r ]; then
        echo "Rebooting..."
        reboot -f
    else
        info "Continuing..."
    fi
}

trap 'fail' 0


# Print a greeting.
info
info "[1;32m<<< NixOS Stage 1 >>>[0m"
info

# Make several required directories.
mkdir -p /etc/udev
touch /etc/fstab # to shut up mount
ln -s /proc/mounts /etc/mtab # to shut up mke2fs
touch /etc/udev/hwdb.bin # to shut up udev
touch /etc/initrd-release

# Function for waiting for device(s) to appear.
waitDevice() {
    local device="$1"
    # Split device string using ':' as a delimiter as bcachefs
    # uses this for multi-device filesystems, i.e. /dev/sda1:/dev/sda2:/dev/sda3
    local IFS=':'

    # USB storage devices tend to appear with some delay.  It would be
    # great if we had a way to synchronously wait for them, but
    # alas...  So just wait for a few seconds for the device to
    # appear.
    for dev in $device; do
        if test ! -e $dev; then
            echo -n "waiting for device $dev to appear..."
            try=20
            while [ $try -gt 0 ]; do
                sleep 1
                # also re-try lvm activation now that new block devices might have appeared
                lvm vgchange -ay
                # and tell udev to create nodes for the new LVs
                udevadm trigger --action=add
                if test -e $dev; then break; fi
                echo -n "."
                try=$((try - 1))
            done
            echo
            [ $try -ne 0 ]
        fi
    done
}

# Mount special file systems.
specialMount() {
  local device="$1"
  local mountPoint="$2"
  local options="$3"
  local fsType="$4"

  mkdir -m 0755 -p "$mountPoint"
  mount -n -t "$fsType" -o "$options" "$device" "$mountPoint"
}
source @earlyMountScript@

# Copy initrd secrets from /.initrd-secrets to their actual destinations
if [ -d "/.initrd-secrets" ]; then
    #
    # Secrets are named by their full destination pathname and stored
    # under /.initrd-secrets/
    #
    for secret in $(cd "/.initrd-secrets"; find . -type f); do
        mkdir -p $(dirname "/$secret")
        cp "/.initrd-secrets/$secret" "$secret"
    done
fi

# Log the script output to /dev/kmsg or /run/log/stage-1-init.log.
mkdir -p /tmp
mkfifo /tmp/stage-1-init.log.fifo
logOutFd=8 && logErrFd=9
eval "exec $logOutFd>&1 $logErrFd>&2"
if test -w /dev/kmsg; then
    tee -i < /tmp/stage-1-init.log.fifo /proc/self/fd/"$logOutFd" | while read -r line; do
        if test -n "$line"; then
            echo "<7>stage-1-init: [$(date)] $line" > /dev/kmsg
        fi
    done &
else
    mkdir -p /run/log
    tee -i < /tmp/stage-1-init.log.fifo /run/log/stage-1-init.log &
fi
exec > /tmp/stage-1-init.log.fifo 2>&1


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
        boot.persistence=*)
            set -- $(IFS==; echo $o)
            persistence=$2
            ;;
        boot.persistence.opt=*)
            set -- $(IFS==; echo $o)
            persistence_opt=$2
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
        copytoram)
            copytoram=1
            ;;
        findiso=*)
            # if an iso name is supplied, try to find the device where
            # the iso resides on
            set -- $(IFS==; echo $o)
            isoPath=$2
            ;;
    esac
done

# Set hostid before modules are loaded.
# This is needed by the spl/zfs modules.
@setHostId@

# Load the required kernel modules.
mkdir -p /lib
ln -s @modulesClosure@/lib/modules /lib/modules
ln -s @modulesClosure@/lib/firmware /lib/firmware
# see comment in stage-1.nix for explanation
echo @extraUtils@/bin/modprobe-kernel > /proc/sys/kernel/modprobe
for i in @kernelModules@; do
    info "loading module $(basename $i)..."
    modprobe $i
done


# Create device nodes in /dev.
@preDeviceCommands@
info "running udev..."
ln -sfn /proc/self/fd /dev/fd
ln -sfn /proc/self/fd/0 /dev/stdin
ln -sfn /proc/self/fd/1 /dev/stdout
ln -sfn /proc/self/fd/2 /dev/stderr
mkdir -p /etc/systemd
ln -sfn @linkUnits@ /etc/systemd/network
mkdir -p /etc/udev
ln -sfn @udevRules@ /etc/udev/rules.d
mkdir -p /dev/.mdadm
systemd-udevd --daemon
udevadm trigger --action=add
udevadm settle


# XXX: Use case usb->lvm will still fail, usb->luks->lvm is covered
@preLVMCommands@

info "starting device mapper and LVM..."
lvm vgchange -ay

if test -n "$debug1devices"; then fail; fi


@postDeviceCommands@


# Check the specified file system, if appropriate.
checkFS() {
    local device="$1"
    local fsType="$2"

    # Only check block devices.
    if [ ! -b "$device" ]; then return 0; fi

    # Don't check ROM filesystems.
    if [ "$fsType" = iso9660 -o "$fsType" = udf ]; then return 0; fi

    # Don't check resilient COWs as they validate the fs structures at mount time
    if [ "$fsType" = btrfs -o "$fsType" = zfs -o "$fsType" = bcachefs ]; then return 0; fi

    # Skip fsck for apfs as the fsck utility does not support repairing the filesystem (no -a option)
    if [ "$fsType" = apfs ]; then return 0; fi

    # Skip fsck for nilfs2 - not needed by design and no fsck tool for this filesystem.
    if [ "$fsType" = nilfs2 ]; then return 0; fi

    # Skip fsck for inherently readonly filesystems.
    if [ "$fsType" = squashfs ]; then return 0; fi

    # If we couldn't figure out the FS type, then skip fsck.
    if [ "$fsType" = auto ]; then
        echo 'cannot check filesystem with type "auto"!'
        return 0
    fi

    # Device might be already mounted manually
    # e.g. NBD-device or the host filesystem of the file which contains encrypted root fs
    if mount | grep -q "^$device on "; then
        echo "skip checking already mounted $device"
        return 0
    fi

    # Optionally, skip fsck on journaling filesystems.  This option is
    # a hack - it's mostly because e2fsck on ext3 takes much longer to
    # recover the journal than the ext3 implementation in the kernel
    # does (minutes versus seconds).
    if test -z "@checkJournalingFS@" -a \
        \( "$fsType" = ext3 -o "$fsType" = ext4 -o "$fsType" = reiserfs \
        -o "$fsType" = xfs -o "$fsType" = jfs -o "$fsType" = f2fs \)
    then
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

    # Filter out x- options, which busybox doesn't do yet.
    local optionsFiltered="$(IFS=,; for i in $options; do if [ "${i:0:2}" != "x-" ]; then echo -n $i,; fi; done)"
    # Prefix (lower|upper|work)dir with /mnt-root (overlayfs)
    local optionsPrefixed="$( echo "$optionsFiltered" | sed -E 's#\<(lowerdir|upperdir|workdir)=#\1=/mnt-root#g' )"

    echo "$device /mnt-root$mountPoint $fsType $optionsPrefixed" >> /etc/fstab

    checkFS "$device" "$fsType"

    # Optionally resize the filesystem.
    case $options in
        *x-nixos.autoresize*)
            if [ "$fsType" = ext2 -o "$fsType" = ext3 -o "$fsType" = ext4 ]; then
                modprobe "$fsType"
                echo "resizing $device..."
                e2fsck -fp "$device"
                resize2fs "$device"
            elif [ "$fsType" = f2fs ]; then
                echo "resizing $device..."
                fsck.f2fs -fp "$device"
                resize.f2fs "$device"
            fi
            ;;
    esac

    # Create backing directories for overlayfs
    if [ "$fsType" = overlay ]; then
        for i in upper work; do
             dir="$( echo "$optionsPrefixed" | grep -o "${i}dir=[^,]*" )"
             mkdir -m 0700 -p "${dir##*=}"
        done
    fi

    info "mounting $device on $mountPoint..."

    mkdir -p "/mnt-root$mountPoint"

    # For ZFS and CIFS mounts, retry a few times before giving up.
    # We do this for ZFS as a workaround for issue NixOS/nixpkgs#25383.
    local n=0
    while true; do
        mount "/mnt-root$mountPoint" && break
        if [ \( "$fsType" != cifs -a "$fsType" != zfs \) -o "$n" -ge 10 ]; then fail; break; fi
        echo "retrying..."
        sleep 1
        n=$((n + 1))
    done

    [ "$mountPoint" == "/" ] &&
        [ -f "/mnt-root/etc/NIXOS_LUSTRATE" ] &&
        lustrateRoot "/mnt-root"

    true
}

lustrateRoot () {
    local root="$1"

    echo
    echo -e "\e[1;33m<<< NixOS is now lustrating the root filesystem (cruft goes to /old-root) >>>\e[0m"
    echo

    mkdir -m 0755 -p "$root/old-root.tmp"

    echo
    echo "Moving impurities out of the way:"
    for d in "$root"/*
    do
        [ "$d" == "$root/nix"          ] && continue
        [ "$d" == "$root/boot"         ] && continue # Don't render the system unbootable
        [ "$d" == "$root/old-root.tmp" ] && continue

        mv -v "$d" "$root/old-root.tmp"
    done

    # Use .tmp to make sure subsequent invokations don't clash
    mv -v "$root/old-root.tmp" "$root/old-root"

    mkdir -m 0755 -p "$root/etc"
    touch "$root/etc/NIXOS"

    exec 4< "$root/old-root/etc/NIXOS_LUSTRATE"

    echo
    echo "Restoring selected impurities:"
    while read -u 4 keeper; do
        dirname="$(dirname "$keeper")"
        mkdir -m 0755 -p "$root/$dirname"
        cp -av "$root/old-root/$keeper" "$root/$keeper"
    done

    exec 4>&-
}



if test -e /sys/power/resume -a -e /sys/power/disk; then
    if test -n "@resumeDevice@" && waitDevice "@resumeDevice@"; then
        resumeDev="@resumeDevice@"
        resumeInfo="$(udevadm info -q property "$resumeDev" )"
    else
        for sd in @resumeDevices@; do
            # Try to detect resume device. According to Ubuntu bug:
            # https://bugs.launchpad.net/ubuntu/+source/pm-utils/+bug/923326/comments/1
            # when there are multiple swap devices, we can't know where the hibernate
            # image will reside. We can check all of them for swsuspend blkid.
            if waitDevice "$sd"; then
                resumeInfo="$(udevadm info -q property "$sd")"
                if [ "$(echo "$resumeInfo" | sed -n 's/^ID_FS_TYPE=//p')" = "swsuspend" ]; then
                    resumeDev="$sd"
                    break
                fi
            fi
        done
    fi
    if test -n "$resumeDev"; then
        resumeMajor="$(echo "$resumeInfo" | sed -n 's/^MAJOR=//p')"
        resumeMinor="$(echo "$resumeInfo" | sed -n 's/^MINOR=//p')"
        echo "$resumeMajor:$resumeMinor" > /sys/power/resume 2> /dev/null || echo "failed to resume..."
    fi
fi

# If we have a path to an iso file, find the iso and link it to /dev/root
if [ -n "$isoPath" ]; then
  mkdir -p /findiso

  for delay in 5 10; do
    blkid | while read -r line; do
      device=$(echo "$line" | sed 's/:.*//')
      type=$(echo "$line" | sed 's/.*TYPE="\([^"]*\)".*/\1/')

      mount -t "$type" "$device" /findiso
      if [ -e "/findiso$isoPath" ]; then
        ln -sf "/findiso$isoPath" /dev/root
        break 2
      else
        umount /findiso
      fi
    done

    sleep "$delay"
  done
fi

# Try to find and mount the root device.
mkdir -p $targetRoot

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

    if test -z "$pseudoDevice" && ! waitDevice "$device"; then
        # If it doesn't appear, try to mount it anyway (and
        # probably fail).  This is a fallback for non-device "devices"
        # that we don't properly recognise.
        echo "Timed out waiting for device $device, trying to mount anyway."
    fi

    # Wait once more for the udev queue to empty, just in case it's
    # doing something with $device right now.
    udevadm settle

    # If copytoram is enabled: skip mounting the ISO and copy its content to a tmpfs.
    if [ -n "$copytoram" ] && [ "$device" = /dev/root ] && [ "$mountPoint" = /iso ]; then
      fsType=$(blkid -o value -s TYPE "$device")
      fsSize=$(blockdev --getsize64 "$device" || stat -Lc '%s' "$device")

      mkdir -p /tmp-iso
      mount -t "$fsType" /dev/root /tmp-iso
      mountFS tmpfs /iso size="$fsSize" tmpfs

      cp -r /tmp-iso/* /mnt-root/iso/

      umount /tmp-iso
      rmdir /tmp-iso
      continue
    fi

    if [ "$mountPoint" = / ] && [ "$device" = tmpfs ] && [ ! -z "$persistence" ]; then
        echo persistence...
        waitDevice "$persistence"
        echo enabling persistence...
        mountFS "$persistence" "$mountPoint" "$persistence_opt" "auto"
        continue
    fi

    mountFS "$device" "$mountPoint" "$options" "$fsType"
done

exec 3>&-


@postMountCommands@


# Emit a udev rule for /dev/root to prevent systemd from complaining.
if [ -e /mnt-root/iso ]; then
    eval $(udevadm info --export --export-prefix=ROOT_ --device-id-of-file=/mnt-root/iso)
else
    eval $(udevadm info --export --export-prefix=ROOT_ --device-id-of-file=$targetRoot)
fi
if [ "$ROOT_MAJOR" -a "$ROOT_MINOR" -a "$ROOT_MAJOR" != 0 ]; then
    mkdir -p /run/udev/rules.d
    echo 'ACTION=="add|change", SUBSYSTEM=="block", ENV{MAJOR}=="'$ROOT_MAJOR'", ENV{MINOR}=="'$ROOT_MINOR'", SYMLINK+="root"' > /run/udev/rules.d/61-dev-root-link.rules
fi


# Stop udevd.
udevadm control --exit

# Reset the logging file descriptors.
# Do this just before pkill, which will kill the tee process.
exec 1>&$logOutFd 2>&$logErrFd
eval "exec $logOutFd>&- $logErrFd>&-"

# Kill any remaining processes, just to be sure we're not taking any
# with us into stage 2. But keep storage daemons like unionfs-fuse.
#
# Storage daemons are distinguished by an @ in front of their command line:
# https://www.freedesktop.org/wiki/Software/systemd/RootStorageDaemons/
for pid in $(pgrep -v -f '^@'); do
    # Make sure we don't kill kernel processes, see #15226 and:
    # http://stackoverflow.com/questions/12213445/identifying-kernel-threads
    readlink "/proc/$pid/exe" &> /dev/null || continue
    # Try to avoid killing ourselves.
    [ $pid -eq $$ ] && continue
    kill -9 "$pid"
done

if test -n "$debug1mounts"; then fail; fi


# Restore /proc/sys/kernel/modprobe to its original value.
echo /sbin/modprobe > /proc/sys/kernel/modprobe


# Start stage 2.  `switch_root' deletes all files in the ramfs on the
# current root.  The path has to be valid in the chroot not outside.
if [ ! -e "$targetRoot/$stage2Init" ]; then
    stage2Check=${stage2Init}
    while [ "$stage2Check" != "${stage2Check%/*}" ] && [ ! -L "$targetRoot/$stage2Check" ]; do
        stage2Check=${stage2Check%/*}
    done
    if [ ! -L "$targetRoot/$stage2Check" ]; then
        echo "stage 2 init script ($targetRoot/$stage2Init) not found"
        fail
    fi
fi

mkdir -m 0755 -p $targetRoot/proc $targetRoot/sys $targetRoot/dev $targetRoot/run

mount --move /proc $targetRoot/proc
mount --move /sys $targetRoot/sys
mount --move /dev $targetRoot/dev
mount --move /run $targetRoot/run

exec env -i $(type -P switch_root) "$targetRoot" "$stage2Init"

fail # should never be reached
