# This configuration has / on a LVM volume.  Since Grub
# doesn't know about LVM, a separate /boot is therefore
# needed.  In particular you need to set "copyKernels"
# to tell NixOS to copy kernels and initrds from /nix/store
# to /boot, and "bootMount" to tell Grub the /boot device
# in Grub syntax (e.g. (hd0,0) for /dev/sda1).
#
# In this example, labels are used for file systems and
# swap devices: "boot" might be /dev/sda1, "root" might be
# /dev/my-volume-group/root, and "swap" might be /dev/sda2.
# In particular there is no specific reference to the fact
# that / is on LVM; that's figured out automatically.

{
  boot = {
    grubDevice = "/dev/sda";
    initrd.kernelModules = ["ata_piix"];
    copyKernels = true;
    bootMount = "(hd0,0)";
  };

  fileSystems = [
    { mountPoint = "/";
      label = "root";
    }
    { mountPoint = "/boot";
      label = "boot";
    }
  ];

  swapDevices = [
    { label = "swap"; }
  ];
}
