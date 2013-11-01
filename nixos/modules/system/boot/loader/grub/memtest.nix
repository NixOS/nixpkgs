# This module adds Memtest86+ to the GRUB boot menu.

{ config, pkgs, ... }:

with pkgs.lib;

let
  memtest86 = pkgs.memtest86plus;
in

{
  options = {

    boot.loader.grub.memtest86 = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Make Memtest86+, a memory testing program, available from the
        GRUB boot menu.
      '';
    };
  };

  config = mkIf config.boot.loader.grub.memtest86 {

    boot.loader.grub.extraEntries =
      if config.boot.loader.grub.version == 2 then
        ''
          menuentry "Memtest86+" {
            linux16 @bootRoot@/memtest.bin
          }
        ''
      else
        throw "Memtest86+ is not supported with GRUB 1.";

    boot.loader.grub.extraFiles."memtest.bin" = "${memtest86}/memtest.bin";

  };
}
