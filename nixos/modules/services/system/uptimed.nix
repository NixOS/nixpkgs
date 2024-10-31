{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.uptimed;
  stateDir = "/var/lib/uptimed";
in
{
  options = {
    services.uptimed = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable `uptimed`, allowing you to track
          your highest uptimes.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.uptimed ];

    users.users.uptimed = {
      description = "Uptimed daemon user";
      home        = stateDir;
      uid         = config.ids.uids.uptimed;
      group       = "uptimed";
    };
    users.groups.uptimed = {};

    systemd.services.uptimed = {
      unitConfig.Documentation = "man:uptimed(8) man:uprecords(1)";
      description = "uptimed service";
      wantedBy    = [ "multi-user.target" ];

      serviceConfig = {
        Restart                 = "on-failure";
        User                    = "uptimed";
        Nice                    = 19;
        IOSchedulingClass       = "idle";
        PrivateTmp              = "yes";
        PrivateNetwork          = "yes";
        NoNewPrivileges         = "yes";
        StateDirectory          = [ "uptimed" ];
        InaccessibleDirectories = "/home";
        ExecStart               = "${pkgs.uptimed}/sbin/uptimed -f -p ${stateDir}/pid";
      };

      preStart = ''
        if ! test -f ${stateDir}/bootid ; then
          ${pkgs.uptimed}/sbin/uptimed -b
        fi
      '';
    };
  };
}
