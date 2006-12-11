let

  configuration = {
    boot = {
      autoDetectRootDevice = false;
      rootDevice = "/dev/hda1";
      readOnlyRoot = false;
      grubDevice = "/dev/hda";
    };
  };

  # Build boot scripts.
  bootEnv = import ./boot-environment.nix {
    stage2Init = ""; # Passed on the command line via Grub.
    inherit configuration;
  };

  # Extra kernel command line arguments.
  extraKernelParams = [
    "selinux=0"
    "apm=on"
    "acpi=on"
    "vga=0x317"
    "console=tty1"
    "splash=verbose"
  ];

in

with bootEnv;
  
rec {

  inherit upstartJobs;


  system = pkgs.stdenvNew.mkDerivation {
    name = "system-configuration";
    builder = ./system-configuration.sh;
    switchToConfiguration = ./switch-to-configuration.sh;
    inherit (pkgs) grub coreutils gnused gnugrep diffutils findutils;
    grubDevice = "/dev/hda"; # !!!
    inherit bootStage2;
    inherit activateConfiguration;
    inherit grubMenuBuilder;
    inherit etc;
    kernel = pkgs.kernel + "/vmlinuz";
    initrd = initialRamdisk + "/initrd";
    inherit extraKernelParams;
    # Most of these are needed by grub-install.
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep pkgs.findutils pkgs.diffutils];
  };


  grubMenuBuilder = pkgs.substituteAll {
    src = ../installer/grub-menu-builder.sh;
    isExecutable = true;
    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
  };


}
