{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.localtimed;
in {
  imports = [ (lib.mkRenamedOptionModule [ "services" "localtime" ] [ "services" "localtimed" ]) ];

  options = {
    services.localtimed = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable `localtimed`, a simple daemon for keeping the
          system timezone up-to-date based on the current location. It uses
          geoclue2 to determine the current location.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.geoclue2.appConfig.localtimed = {
      isAllowed = true;
      isSystem = true;
    };

    # Install the polkit rules.
    environment.systemPackages = [ pkgs.localtime ];
    # Install the systemd unit.
    systemd.packages = [ pkgs.localtime ];

    systemd.services.localtime.wantedBy = [ "multi-user.target" ];
  };
}
