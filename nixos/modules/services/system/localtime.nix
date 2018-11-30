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

    # so polkit will pick up the rules
    environment.systemPackages = [ pkgs.localtime ];

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
