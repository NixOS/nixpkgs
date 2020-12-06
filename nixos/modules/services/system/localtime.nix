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

    # We use the 'out' output, since localtime has its 'bin' output
    # first, so that is what we get if we use the derivation bare.
    # Install the polkit rules.
    environment.systemPackages = [ pkgs.localtime.out ];
    # Install the systemd unit.
    systemd.packages = [ pkgs.localtime.out ];

    users.users.localtimed = {
      description = "Taskserver user";
    };

    systemd.services.localtime = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Restart = "on-failure";
    };
  };
}
