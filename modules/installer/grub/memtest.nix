# This module adds Memtest86 to the Grub boot menu on the CD.  !!! It
# would be nice if this also worked for normal configurations.

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
        menuentry "Memtest86+" {
          linux16 $bootRoot/memtest.bin
        }
      '';
    extraPrepareConfig =
      ''
        cp ${pkgs.memtest86}/memtest.bin /boot/memtest.bin;
      '';
  };
}
