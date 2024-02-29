{ config, lib, pkgs, utils, ... }:

with lib;

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

    boot.loader.generationsDir = utils.mkBootLoaderOption {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to create symlinks to the system generations under
          `/boot`.  When enabled,
          `/boot/default/kernel`,
          `/boot/default/initrd`, etc., are updated to
          point to the current generation's kernel image, initial RAM
          disk, and other bootstrap files.

          This optional is not necessary with boot loaders such as GNU GRUB
          for which the menu is updated to point to the latest bootstrap
          files.  However, it is needed for U-Boot on platforms where the
          boot command line is stored in flash memory rather than in a
          menu file.
        '';
      };

      copyKernels = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether copy the necessary boot files into /boot, so
          /nix/store is not needed by the boot loader.
        '';
      };

    };

  };


  config = mkIf config.boot.loader.generationsDir.enable {
    boot.loader.generationsDir = {
      installHook = generationsDirBuilder;
      id = "generationsDir";
    };
    system.boot.loader.kernelFile = pkgs.stdenv.hostPlatform.linux-kernel.target;
  };
}
