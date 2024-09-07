{ lib, ... }:

with lib;

{
  imports = [
    (mkRenamedOptionModule [ "boot" "loader" "grub" "timeout" ] [ "boot" "loader" "timeout" ])
    (mkRenamedOptionModule [ "boot" "loader" "gummiboot" "timeout" ] [ "boot" "loader" "timeout" ])
  ];

    options = {
        boot.loader.timeout =  mkOption {
            default = 5;
            type = types.nullOr types.int;
            description = ''
              Timeout (in seconds) until loader boots the default menu item. Use null if the loader menu should be displayed indefinitely.
            '';
        };
    };
}
