{ config, lib, utils, ... }:

with lib;

{
  meta = {
    maintainers = with maintainers; [ raitobezarius ];
  };

  options.boot.loader.defaults = utils.mkBootLoaderOption {
    enable = mkOption {
      default = false;
      readOnly = true;
      type = types.bool;
      internal = true;
    };

    timeout = mkOption {
      default = 5;
      type = types.nullOr types.int;
      description = lib.mdDoc ''
        Timeout (in seconds) until bootloader starts the default menu item.
        Use `null` to require the user to select an entry.

        Not all bootloaders supports timeouts.
      '';
    };
  };

  config = {
    boot.loader.defaults = {
      id = "fake-bootloader-for-defaults";
      installHook = "";
    };
  };
}
