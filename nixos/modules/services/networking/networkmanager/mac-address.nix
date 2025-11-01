{
  config,
  lib,
  ...
}:
let
  cfg = config.networking.networkmanager;

  mkMacAddressOption =
    {
      forWifi ? false,
    }:
    lib.mkOption {
      default = "preserve";
      example = "00:11:22:33:44:55";

      description = ''
        Set the MAC address of the interface.

        - `"XX:XX:XX:XX:XX:XX"`: MAC address of the interface
        - `"permanent"`: Use the permanent MAC address of the device
        - `"preserve"`: Don't change the MAC address of the device upon activation
        - `"random"`: Generate a randomized value upon each connect
        - `"stable"`: Generate a stable, hashed MAC address
      ''
      ++ lib.optionals forWifi ''
        - `"stable-ssid"`: Generate a stable MAC addressed based on Wi-Fi network
      '';

      type = lib.types.either lib.types.str (
        lib.types.enum [
          "permanent"
          "preserve"
          "random"
          "stable"
        ]
        ++ lib.optionals forWifi [
          "stable-ssid"
        ]
      );

    };
in
{
  options = {
    networking.networkmanager = {
      ethernet.macAddress = mkMacAddressOption {
        forWifi = false;
      };

      wifi = {
        macAddress = mkMacAddressOption {
          forWifi = true;
        };

        scanRandMacAddress = lib.mkOption {
          default = true;
          description = ''
            Whether to enable MAC address randomization of a Wi-Fi device
            during scanning.
          '';

          type = lib.types.bool;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager = {
      connectionConfig = {
        "ethernet.cloned-mac-address" = cfg.ethernet.macAddress;
        "wifi.cloned-mac-address" = cfg.wifi.macAddress;
      };

      settings = {
        device."wifi.scan-rand-mac-address" = cfg.wifi.scanRandMacAddress;
      };
    };
  };
}
