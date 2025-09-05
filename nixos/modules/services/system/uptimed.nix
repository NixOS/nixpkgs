{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.uptimed;
  stateDir = "/var/lib/uptimed";
in
{
  options = {
    services.uptimed = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable `uptimed`, allowing you to track
          your highest uptimes.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.uptimed ];

    systemd.services.uptimed = {
      unitConfig.Documentation = "man:uptimed(8) man:uprecords(1)";
      description = "uptimed service";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "notify";
        Restart = "on-failure";
        User = "uptimed";
        DynamicUser = true;
        Nice = 19;
        IOSchedulingClass = "idle";
        PrivateTmp = "yes";
        PrivateNetwork = "yes";
        NoNewPrivileges = "yes";
        StateDirectory = [ "uptimed" ];
        InaccessibleDirectories = "/home";
        ExecStart = "${pkgs.uptimed}/sbin/uptimed -f -p ${stateDir}/pid";
      };

      preStart = ''
        if ! test -f ${stateDir}/bootid ; then
          ${pkgs.uptimed}/sbin/uptimed -b
        fi
      '';
    };
  };
}
