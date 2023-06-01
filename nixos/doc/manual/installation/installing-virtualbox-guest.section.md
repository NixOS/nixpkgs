# Installing in a VirtualBox guest {#sec-installing-virtualbox-guest}

Installing NixOS into a VirtualBox guest is convenient for users who
want to try NixOS without installing it on bare metal. If you want to
use a pre-made VirtualBox appliance, it is available at [the downloads
page](https://nixos.org/nixos/download.html). If you want to set up a
VirtualBox guest manually, follow these instructions:

1.  Add a New Machine in VirtualBox with OS Type "Linux / Other Linux"

1.  Base Memory Size: 768 MB or higher.

1.  New Hard Disk of 8 GB or higher.

1.  Mount the CD-ROM with the NixOS ISO (by clicking on CD/DVD-ROM)

1.  Click on Settings / System / Processor and enable PAE/NX

1.  Click on Settings / System / Acceleration and enable "VT-x/AMD-V"
    acceleration

1.  Click on Settings / Display / Screen and select VMSVGA as Graphics
    Controller

1.  Save the settings, start the virtual machine, and continue
    installation like normal

There are a few modifications you should make in configuration.nix.
Enable booting:

```nix
boot.loader.grub.device = "/dev/sda";
```

Also remove the fsck that runs at startup. It will always fail to run,
stopping your boot until you press `*`.

```nix
boot.initrd.checkJournalingFS = false;
```

Shared folders can be given a name and a path in the host system in the
VirtualBox settings (Machine / Settings / Shared Folders, then click on
the "Add" icon). Add the following to the
`/etc/nixos/configuration.nix` to auto-mount them. If you do not add
`"nofail"`, the system will not boot properly.

```nix
{ config, pkgs, ...} :
{
  fileSystems."/virtualboxshare" = {
    fsType = "vboxsf";
    device = "nameofthesharedfolder";
    options = [ "rw" "nofail" ];
  };
}
```

The folder will be available directly under the root directory.
