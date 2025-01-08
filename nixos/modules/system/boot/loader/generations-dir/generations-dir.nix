{ config, lib, pkgs, ... }:

let

  generationsDirBuilder = pkgs.substituteAll {
    src = ./generations-dir-builder.sh;
    isExecutable = true;
    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
    inherit (config.boot.loader.generationsDir) copyKernels;
  };

in

{
  options = {

    boot.loader.generationsDir = {

      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to create symlinks to the system generations under
          `/boot`.  When enabled,
          `/boot/default/kernel`,
          `/boot/default/initrd`, etc., are updated to
          point to the current generation's kernel image, initial RAM
          disk, and other bootstrap files.

          This lib.optional is not necessary with boot loaders such as GNU GRUB
          for which the menu is updated to point to the latest bootstrap
          files.  However, it is needed for U-Boot on platforms where the
          boot command line is stored in flash memory rather than in a
          menu file.
        '';
      };

      copyKernels = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to copy the necessary boot files into /boot, so
          /nix/store is not needed by the boot loader.
        '';
      };

    };

  };


  config = lib.mkIf config.boot.loader.generationsDir.enable {

    system.build.installBootLoader = generationsDirBuilder;
    system.boot.loader.id = "generationsDir";
    system.boot.loader.kernelFile = pkgs.stdenv.hostPlatform.linux-kernel.target;

  };
}
