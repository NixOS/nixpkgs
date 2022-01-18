{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.localtime;
in {
  options = {
    services.localtime = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable <literal>localtime</literal>, simple daemon for keeping the system
          timezone up-to-date based on the current location. It uses geoclue2 to
          determine the current location and systemd-timedated to actually set
          the timezone.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.geoclue2 = {
      enable = true;
      appConfig.localtime = {
        isAllowed = true;
        isSystem = true;
      };
    };

    # Install the polkit rules.
    environment.systemPackages = [ pkgs.localtime ];
    # Install the systemd unit.
    systemd.packages = [ pkgs.localtime ];

    users.users.localtimed = {
      description = "localtime daemon";
      isSystemUser = true;
      group = "localtimed";
    };
    users.groups.localtimed = {};

    systemd.services.localtime = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Restart = "on-failure";
    };
  };
}
