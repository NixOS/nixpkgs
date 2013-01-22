# This module allows getting memtest86 in grub menus.

{config, pkgs, ...}:

with pkgs.lib;
let
  isEnabled = config.boot.loader.grub.memtest86;
  memtest86 = pkgs.memtest86plus;
in
{
  options = {
    boot.loader.grub.memtest86 = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Make Memtest86+, a memory testing program, available from the
        GRUB menu.
      '';
    };
  };

  config.boot.loader.grub = mkIf isEnabled {
    extraEntries = if config.boot.loader.grub.version == 2 then
      ''
        menuentry "${memtest86.name}" {
          linux16 @bootRoot@/memtest.bin
        }
      ''
      else
      ''
        menuentry "${memtest86.name}"
          linux16 @bootRoot@/memtest.bin
      '';
    extraPrepareConfig =
      ''
        ${pkgs.coreutils}/bin/cp ${memtest86}/memtest.bin /boot/memtest.bin;
      '';
  };
}
