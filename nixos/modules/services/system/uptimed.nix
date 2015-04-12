{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.uptimed;
in
{
  options = {
    services.uptimed = {
      enable = mkOption {
        default = false;
        description = ''
          Enable <literal>uptimed</literal>, allowing you to track
          your highest uptimes.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers.uptimed = {
      description = "Uptimed daemon user";
      home        = "/var/spool/uptimed";
      createHome  = true;
      uid         = config.ids.uids.uptimed;
    };

    systemd.services.uptimed = {
      unitConfig.Documentation = "man:uptimed(8) man:uprecords(1)";
      description = "uptimed service";
      wantedBy    = [ "multi-user.target" ];

      serviceConfig.Restart                 = "on-failure";
      serviceConfig.User                    = "uptimed";
      serviceConfig.Nice                    = 19;
      serviceConfig.IOSchedulingClass       = "idle";
      serviceConfig.PrivateTmp              = "yes";
      serviceConfig.PrivateNetwork          = "yes";
      serviceConfig.NoNewPrivileges         = "yes";
      serviceConfig.ReadWriteDirectories    = "/var/spool/uptimed";
      serviceConfig.InaccessibleDirectories = "/home";

      preStart = ''
        mkdir -m 0755 -p /var/spool/uptimed
        chown uptimed    /var/spool/uptimed

        if ! test -f /var/spool/uptimed/bootid ; then
          ${pkgs.uptimed}/sbin/uptimed -b
        fi
      '';
      serviceConfig.ExecStart =
        "${pkgs.uptimed}/sbin/uptimed -f -p /var/spool/uptimed/pid";
    };
  };
}
