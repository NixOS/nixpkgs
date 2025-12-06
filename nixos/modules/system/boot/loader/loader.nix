{ lib, ... }:

with lib;

{
  imports = [
    (mkRenamedOptionModule [ "boot" "loader" "grub" "timeout" ] [ "boot" "loader" "timeout" ])
    (mkRenamedOptionModule [ "boot" "loader" "gummiboot" "timeout" ] [ "boot" "loader" "timeout" ])
  ];

  options.boot.loader = {
    timeout = mkOption {
      default = 5;
      type = types.nullOr types.int;
      description = ''
        Timeout (in seconds) until loader boots the default menu item. Use null if the loader menu should be displayed indefinitely.
      '';
    };

    timestampFormat = mkOption {
      default = "%F";
      example = "%F %H:%M";
      type = types.str;
      description = ''
        How to display timestamps in the boot menu, in strftime format. See [the strftime manpage](https://www.man7.org/linux/man-pages/man3/strftime.3.html)
      '';
    };
  };
}
