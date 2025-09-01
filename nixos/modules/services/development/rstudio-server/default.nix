{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.rstudio-server;

  rserver-conf = builtins.toFile "rserver.conf" ''
    server-working-dir=${cfg.serverWorkingDir}
    www-address=${cfg.listenAddr}
    ${cfg.rserverExtraConfig}
  '';

  rsession-conf = builtins.toFile "rsession.conf" ''
    ${cfg.rsessionExtraConfig}
  '';

in
{
  meta.maintainers = with lib.maintainers; [
    jbedo
    cfhammill
  ];

  options.services.rstudio-server = {
    enable = lib.mkEnableOption "RStudio server";

    serverWorkingDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/rstudio-server";
      description = ''
        Default working directory for server (server-working-dir in rserver.conf).
      '';
    };

    listenAddr = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = ''
        Address to listen on (www-address in rserver.conf).
      '';
    };

    package = lib.mkPackageOption pkgs "rstudio-server" {
      example = "rstudioServerWrapper.override { packages = [ pkgs.rPackages.ggplot2 ]; }";
    };

    rserverExtraConfig = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Extra contents for rserver.conf.
      '';
    };

    rsessionExtraConfig = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Extra contents for resssion.conf.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    systemd.services.rstudio-server = {
      description = "Rstudio server";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [
        rserver-conf
        rsession-conf
      ];

      serviceConfig = {
        Restart = "on-failure";
        Type = "forking";
        ExecStart = "${cfg.package}/bin/rserver";
        StateDirectory = "rstudio-server";
        RuntimeDirectory = "rstudio-server";
      };
    };

    environment.etc = {
      "rstudio/rserver.conf".source = rserver-conf;
      "rstudio/rsession.conf".source = rsession-conf;
      "pam.d/rstudio".source = "/etc/pam.d/login";
    };
    environment.systemPackages = [ cfg.package ];

    users = {
      users.rstudio-server = {
        uid = config.ids.uids.rstudio-server;
        description = "rstudio-server";
        group = "rstudio-server";
      };
      groups.rstudio-server = {
        gid = config.ids.gids.rstudio-server;
      };
    };

  };
}
