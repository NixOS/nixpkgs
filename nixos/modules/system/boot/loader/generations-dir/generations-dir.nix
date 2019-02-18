{ config, lib, pkgs, ... }:

with lib;

let

  generationsDirBuilder = pkgs.substituteAll {
    src = ./generations-dir-builder.sh;
    isExecutable = true;
    inherit (pkgs.buildPackages) bash;
    path = with pkgs.buildPackages; [coreutils gnused gnugrep];
    inherit (config.boot.loader.generationsDir) copyKernels;
  };

  # Temporary check, for nixos to cope both with nixpkgs stdenv-updates and trunk
  inherit (pkgs.stdenv.hostPlatform) platform;

in

{
  options = {

    boot.loader.generationsDir = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to create symlinks to the system generations under
          <literal>/boot</literal>.  When enabled,
          <literal>/boot/default/kernel</literal>,
          <literal>/boot/default/initrd</literal>, etc., are updated to
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
        description = ''
          Whether copy the necessary boot files into /boot, so
          /nix/store is not needed by the boot loader.
        '';
      };

    };

  };


  config = mkIf config.boot.loader.generationsDir.enable {

    system.build.installBootLoader = generationsDirBuilder;
    system.boot.loader.id = "generationsDir";
    system.boot.loader.kernelFile = platform.kernelTarget;

  };
}
