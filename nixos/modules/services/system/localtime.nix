{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.localtime;
in {
  options = {
    services.localtime = {
      enable = mkOption {
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
    services.geoclue2.enable = true;

    security.polkit.extraConfig = ''
     polkit.addRule(function(action, subject) {
       if (action.id == "org.freedesktop.timedate1.set-timezone"
           && subject.user == "localtimed") {
         return polkit.Result.YES;
       }
     });
    '';

    users.users = [{
      name = "localtimed";
      description = "Taskserver user";
    }];

    systemd.services.localtime = {
      description = "localtime service";
      wantedBy = [ "multi-user.target" ];
      partOf = [ "geoclue.service "];

      serviceConfig = {
        Restart                 = "on-failure";
        # TODO: make it work with dbus
        #DynamicUser             = true;
        Nice                    = 10;
        User                    = "localtimed";
        PrivateTmp              = "yes";
        PrivateDevices          = true;
        PrivateNetwork          = "yes";
        NoNewPrivileges         = "yes";
        ProtectSystem           = "strict";
        ProtectHome             = true;
        ExecStart               = "${pkgs.localtime}/bin/localtimed";
      };
    };
  };
}
