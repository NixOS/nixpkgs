{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.uptimed;
  stateDir = "/var/spool/uptimed";
in
{
  options = {
    services.uptimed = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable <literal>uptimed</literal>, allowing you to track
          your highest uptimes.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.uptimed = {
      description = "Uptimed daemon user";
      home        = stateDir;
      createHome  = true;
      uid         = config.ids.uids.uptimed;
    };

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
        ReadWriteDirectories    = stateDir;
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
