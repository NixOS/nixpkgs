{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.automatic-timezoned;
in
{
  options = {
    services.automatic-timezoned = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable `automatic-timezoned`, simple daemon for keeping the system
          timezone up-to-date based on the current location. It uses geoclue2 to
          determine the current location and systemd-timedated to actually set
          the timezone.
        '';
      };
      package = mkPackageOption pkgs "automatic-timezoned" { };
    };
  };

  config = mkIf cfg.enable {
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.timedate1.set-timezone"
            && subject.user == "automatic-timezoned") {
          return polkit.Result.YES;
        }
      });
    '';

    services.geoclue2 = {
      enable = true;
      appConfig.automatic-timezoned = {
        isAllowed = true;
        isSystem = true;
        users = [ (toString config.ids.uids.automatic-timezoned) ];
      };
    };

    systemd.services = {

      automatic-timezoned = {
        description = "Automatically update system timezone based on location";
        requires = [ "automatic-timezoned-geoclue-agent.service" ];
        after = [ "automatic-timezoned-geoclue-agent.service" ];
        serviceConfig = {
          Type = "exec";
          User = "automatic-timezoned";
          ExecStart = "${cfg.package}/bin/automatic-timezoned";
        };
        wantedBy = [ "default.target" ];
      };

      automatic-timezoned-geoclue-agent = {
        description = "Geoclue agent for automatic-timezoned";
        requires = [ "geoclue.service" ];
        after = [ "geoclue.service" ];
        serviceConfig = {
          Type = "exec";
          User = "automatic-timezoned";
          ExecStart = "${pkgs.geoclue2-with-demo-agent}/libexec/geoclue-2.0/demos/agent";
          Restart = "on-failure";
          PrivateTmp = true;
        };
        wantedBy = [ "default.target" ];
      };

    };

    users = {
      users.automatic-timezoned = {
        description = "automatic-timezoned";
        uid = config.ids.uids.automatic-timezoned;
        group = "automatic-timezoned";
      };
      groups.automatic-timezoned = {
        gid = config.ids.gids.automatic-timezoned;
      };
    };
  };
}
