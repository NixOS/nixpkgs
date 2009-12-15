# this is the configuration which will be installed.
# The configuration is prebuild before starting the vm because starting the vm
# causes some overhead.
{pkgs, config, ...}: {

  # make system boot and accessible:
  require = [ ./installation-cd-minimal-test-insecure.nix ];

  boot.loader.grub = {
    device = "/dev/sda";
    copyKernels = false;
    bootDevice = "(hd0,0)";
  };

  fileSystems = [
    { mountPoint = "/";
      device = "/dev/sda1";
      neededForBoot = true;
    }
  ];

  fonts = {
    enableFontConfig = false; 
  };

}
