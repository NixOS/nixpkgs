{ lib, ... }:

{
  imports = [
    (lib.mkRenamedOptionModule [ "boot" "loader" "grub" "timeout" ] [ "boot" "loader" "timeout" ])
    (lib.mkRenamedOptionModule [ "boot" "loader" "gummiboot" "timeout" ] [ "boot" "loader" "timeout" ])
  ];

  options = {
    boot.loader.timeout = lib.mkOption {
      default = 5;
      type = lib.types.nullOr lib.types.int;
      description = ''
        Timeout (in seconds) until loader boots the default menu item. Use null if the loader menu should be displayed indefinitely.
      '';
    };
  };
}
