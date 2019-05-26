{ lib, ... }:

with lib;

{
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