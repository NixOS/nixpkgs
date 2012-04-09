# This module allows getting memtest86+ in grub menus.

{config, pkgs, ...}:

with pkgs.lib;
let
  isEnabled = config.boot.loader.grub.memtest86;
in
{
  options = {
    boot.loader.grub.memtest86 = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Add a menu entry in grub for memtest86+
      '';
    };
  };

  config.boot.loader.grub = mkIf isEnabled {
    extraEntries = 
      ''
        menuentry "${pkgs.memtest86.name}" {
          linux16 $bootRoot/memtest.bin
        }
      '';
    extraPrepareConfig =
      ''
        cp ${pkgs.memtest86}/memtest.bin /boot/memtest.bin;
      '';
  };
}
