{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.tvheadend;
  pidFile = "${config.users.users.tvheadend.home}/tvheadend.pid";
in

{
  options = {
    services.tvheadend = {
      enable = mkEnableOption "Tvheadend";
      httpPort = mkOption {
        type = types.int;
        default = 9981;
        description = "Port to bind HTTP to.";
      };

      htspPort = mkOption {
        type = types.int;
        default = 9982;
        description = "Port to bind HTSP to.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.tvheadend = {
      description = "Tvheadend Service user";
      home = "/var/lib/tvheadend";
      createHome = true;
      isSystemUser = true;
      group = "tvheadend";
    };
    users.groups.tvheadend = { };

    systemd.services.tvheadend = {
      description = "Tvheadend TV streaming server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "forking";
        PIDFile = pidFile;
        Restart = "always";
        RestartSec = 5;
        User = "tvheadend";
        Group = "video";
        ExecStart = ''
          ${pkgs.tvheadend}/bin/tvheadend \
          --http_port ${toString cfg.httpPort} \
          --htsp_port ${toString cfg.htspPort} \
          -f \
          -C \
          -p ${pidFile} \
          -u tvheadend \
          -g video
        '';
        ExecStop = "${pkgs.coreutils}/bin/rm ${pidFile}";
      };
    };
  };
}
