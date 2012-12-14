Let all the files in the system tarball sit in a directory served by NFS (the
NFS root) like this in exportfs:
  /home/pcroot    192.168.1.0/24(rw,no_root_squash,no_all_squash)

Run "exportfs -a" after editing /etc/exportfs, for the nfs server to be aware
of the changes.

Use a tftp server serving the root of boot/ (from the system tarball).

In order to have PXE boot, use the boot/dhcpd.conf-example file for your dhcpd
server, as it will point your PXE clients to pxelinux.0 from the tftp server.
Adapt the configuration to your network.

Adapt the pxelinux configuration (boot/pxelinux.cfg/default) to set the path to
your nfrroot. If you use ip=dhcp in the kernel, the nfs server ip will be taken
from dhcp and so you don't have to specify it.

The linux in bzImage includes network drivers for some usual cards.


QEMU Testing
---------------

You can test qemu pxe boot without having a DHCP server adapted, but having
nfsroot, like this:
  qemu-system-x86_64 -tftp /home/pcroot/boot -net nic -net user,bootfile=pxelinux.0 -boot n

I don't know how to use NFS through the qemu '-net user' though.


QEMU Testing with NFS root and bridged network
-------------------------------------------------

This allows testing with qemu as any other host in your LAN.

Testing with the real dhcpd server requires setting up a bridge and having a
tap device.
  tunctl -t tap0
  brctl addbr br0
  brctl addif br0 eth0
  brctl addif tap0 eth0
  ifconfig eth0 0.0.0.0 up
  ifconfig tap0 0.0.0.0 up
  ifconfig br0 up # With your ip configuration

Then you can run qemu:
  qemu-system-x86_64 -boot n -net tap,ifname=tap0,script=no -net nic,model=e1000


Using the system-tarball-pc in a chroot
--------------------------------------------------

Installation:
  mkdir nixos-chroot && cd nixos-chroot
  tar xf your-system-tarball.tar.xz
  mkdir sys dev proc tmp root var run
  mount --bind /sys sys
  mount --bind /dev dev
  mount --bind /proc proc

Activate the system: look for a directory in nix/store similar to:
    "/nix/store/y0d1lcj9fppli0hl3x0m0ba5g1ndjv2j-nixos-feb97bx-53f008"
Having found it, activate that nixos system *twice*:
  chroot . /nix/store/SOMETHING-nixos-SOMETHING/activate
  chroot . /nix/store/SOMETHING-nixos-SOMETHING/activate
  
This runs a 'hostname' command. Restore your old hostname with:
  hostname OLDHOSTNAME

Copy your system resolv.conf to the /etc/resolv.conf inside the chroot:
  cp /etc/resolv.conf etc

Then you can get an interactive shell in the nixos chroot. '*' means
to run inside the chroot interactive shell
  chroot . /bin/sh
*  source /etc/profile

Populate the nix database: that should be done in the init script if you
had booted this nixos. Run:
*  `grep local-cmds run/current-system/init`

Then you can proceed normally subscribing to a nixos channel:
  nix-channel --add http://nixos.org/channels/nixos-unstable
  nix-channel --update

Testing:
  nix-env -i hello
  which hello
  hello
