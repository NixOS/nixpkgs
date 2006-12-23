mknod -m 0600 /dev/ttyS0 c 4 64
mknod -m 0600 /dev/ttyS1 c 4 65
mknod -m 0600 /dev/ttyS2 c 4 66
mknod -m 0600 /dev/ttyS3 c 4 67

# base UNIX devices
mknod -m 0600 /dev/mem c 1 1
mknod -m 0666 /dev/null c 1 3
mknod -m 0666 /dev/zero c 1 5

# tty
mknod -m 0600 /dev/tty c 5 0
if ! test -e /dev/console; then
    mknod -m 0600 /dev/console c 5 1
fi

mknod -m 0660 /dev/hda b 3 0
mknod -m 0660 /dev/hda1 b 3 1
mknod -m 0660 /dev/hda2 b 3 2
mknod -m 0660 /dev/hda3 b 3 3

mknod -m 0660 /dev/hdb b 3 64
mknod -m 0660 /dev/hdb1 b 3 65
mknod -m 0660 /dev/hdb2 b 3 66
mknod -m 0660 /dev/hdb3 b 3 67

mknod -m 0660 /dev/hdc b 22 0
mknod -m 0660 /dev/hdc1 b 22 1
mknod -m 0660 /dev/hdc2 b 22 2
mknod -m 0660 /dev/hdc3 b 22 3

mknod -m 0660 /dev/hdd b 22 64
mknod -m 0660 /dev/hdd1 b 22 65
mknod -m 0660 /dev/hdd2 b 22 66
mknod -m 0660 /dev/hdd3 b 22 67

mknod -m 0660 /dev/sda b 8 0
mknod -m 0660 /dev/sda1 b 8 1
mknod -m 0660 /dev/sda2 b 8 2
mknod -m 0660 /dev/sda3 b 8 3

mknod -m 0660 /dev/sr0 b 11 0
