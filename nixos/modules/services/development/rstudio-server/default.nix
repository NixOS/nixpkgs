{ config, lib, pkgs, ... }:

with lib;

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
  meta.maintainers = with maintainers; [ jbedo cfhammill ];

  options.services.rstudio-server = {
    enable = mkEnableOption "RStudio server";

    serverWorkingDir = mkOption {
      type = types.str;
      default = "/var/lib/rstudio-server";
      description = lib.mdDoc ''
        Default working directory for server (server-working-dir in rserver.conf).
      '';
    };

    listenAddr = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        Address to listen on (www-address in rserver.conf).
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rstudio-server;
      defaultText = literalExpression "pkgs.rstudio-server";
      example = literalExpression "pkgs.rstudioServerWrapper.override { packages = [ pkgs.rPackages.ggplot2 ]; }";
      description = lib.mdDoc ''
        Rstudio server package to use. Can be set to rstudioServerWrapper to provide packages.
      '';
    };

    rserverExtraConfig = mkOption {
      type = types.str;
      default = "";
      description = lib.mdDoc ''
        Extra contents for rserver.conf.
      '';
    };

    rsessionExtraConfig = mkOption {
      type = types.str;
      default = "";
      description = lib.mdDoc ''
        Extra contents for resssion.conf.
      '';
    };

  };

  config = mkIf cfg.enable
    {
      systemd.services.rstudio-server = {
        description = "Rstudio server";

        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [ rserver-conf rsession-conf ];

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
