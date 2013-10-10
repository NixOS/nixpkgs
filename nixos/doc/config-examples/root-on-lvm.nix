# This configuration has / on a LVM volume.  Since Grub
# doesn't know about LVM, a separate /boot is therefore
# needed.
#
# In this example, labels are used for file systems and
# swap devices: "boot" might be /dev/sda1, "root" might be
# /dev/my-volume-group/root, and "swap" might be /dev/sda2.
# In particular there is no specific reference to the fact
# that / is on LVM; that's figured out automatically.

{
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.kernelModules = ["ata_piix"];

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
