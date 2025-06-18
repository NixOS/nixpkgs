{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  generationsDirBuilder = pkgs.replaceVarsWith {
    src = ./generations-dir-builder.sh;
    isExecutable = true;
    replacements = {
      inherit (pkgs) bash;
      path = lib.makeBinPath [
        pkgs.coreutils
        pkgs.gnused
        pkgs.gnugrep
      ];
      inherit (config.boot.loader.generationsDir) copyKernels copyDefault;
    };
  };

in

{
  options = {

    boot.loader.generationsDir = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
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
        description = ''
          Whether to copy the necessary boot files into /boot, so
          /nix/store is not needed by the boot loader.
        '';
      };

      copyDefault = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Whether to copy the default system profile boot files to a second set
          of files in `/boot` (`nixos-kernel`, `nixos-initrd`, `nixos-init`).

          Disable this option to save space on the `/boot` partition if your
          boot loader can follow the `default` symlink.

          If you previously enabled this option, you need to clean up the old
          files manually:

          ```
          rm -vf /boot/nixos-{kernel,initrd,init}
          ```
        '';
      };

    };

  };

  config = mkIf config.boot.loader.generationsDir.enable {

    system.build.installBootLoader = generationsDirBuilder;
    system.boot.loader.id = "generationsDir";
    system.boot.loader.kernelFile = pkgs.stdenv.hostPlatform.linux-kernel.target;

  };
}
