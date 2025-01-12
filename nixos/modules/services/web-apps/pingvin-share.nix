{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.pingvin-share;
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkPackageOption
    types
    ;
in

{
  options = {
    services.pingvin-share = {
      enable = mkEnableOption "Pingvin Share, a self-hosted file sharing platform";

      user = mkOption {
        type = types.str;
        default = "pingvin";
        description = ''
          User account under which Pingvin Share runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "pingvin";
        description = ''
          Group under which Pingvin Share runs.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the firewall for the port in {option}`services.pingvin-share.frontend.port`.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/pingvin-share";
        example = "/var/lib/pingvin";
        description = ''
          The path to the data directory in which Pingvin Share will store its data.
        '';
      };

      hostname = mkOption {
        type = types.str;
        default = "localhost:${toString cfg.backend.port}";
        defaultText = lib.literalExpression "localhost:\${options.services.pingvin-share.backend.port}";
        example = "pingvin-share.domain.tdl";
        description = ''
          The domain name of your instance. If null, the redirections will be made to localhost.
        '';
      };

      https = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Whether to enable HTTPS for the domain.
        '';
      };

      backend = {
        package = mkPackageOption pkgs [
          "pingvin-share"
          "backend"
        ] { };

        port = mkOption {
          type = types.port;
          default = 8080;
          example = 9000;
          description = ''
            The port that the backend service of Pingvin Share will listen to.
          '';
        };
      };

      frontend = {
        package = mkPackageOption pkgs [
          "pingvin-share"
          "frontend"
        ] { };

        port = mkOption {
          type = types.port;
          default = 3000;
          example = 8000;
          description = ''
            The port that the frontend service of Pingvin Share will listen to.
          '';
        };
      };

      nginx = {
        enable = mkEnableOption "a Nginx reverse proxy for Pingvin Share.";
      };
    };
  };

  config = mkIf cfg.enable {

    users.groups = mkIf (cfg.group == "pingvin") { pingvin = { }; };

    users.users = mkIf (cfg.user == "pingvin") {
      pingvin = {
        group = cfg.group;
        description = "Pingvin Share daemon user";
        isSystemUser = true;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.frontend.port ];

    systemd.services.pingvin-share-backend = {
      description = "Backend service of Pingvin Share, a self-hosted file sharing platform.";

      wantedBy = [
        "multi-user.target"
        "pingvin-share-frontend.service"
      ];
      before = [ "pingvin-share-frontend.service" ];
      after = [
        "network.target"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];

      environment = {
        PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
        PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
        PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
        PRISMA_INTROSPECTION_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/introspection-engine";
        PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
        PORT = toString cfg.backend.port;
        DATABASE_URL = "file:${cfg.dataDir}/pingvin-share.db?connection_limit=1";
        DATA_DIRECTORY = cfg.dataDir;
      };

      path = with pkgs; [
        cfg.backend.package
        openssl
        prisma-engines
      ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "simple";
        Restart = "on-failure";
        ExecStartPre = [
          "${cfg.backend.package}/node_modules/.bin/prisma migrate deploy"
          "${cfg.backend.package}/node_modules/.bin/prisma db seed"
        ];
        ExecStart = "${cfg.backend.package}/node_modules/.bin/ts-node dist/src/main";
        StateDirectory = mkIf (cfg.dataDir == "/var/lib/pingvin-share") "pingvin-share";
        WorkingDirectory = cfg.backend.package;
      };
    };

    systemd.services.pingvin-share-frontend = {
      description = "Frontend service of Pingvin Share, a self-hosted file sharing platform.";

      wantedBy = [ "multi-user.target" ];
      wants = [
        "network-online.target"
        "pingvin-share-backend.service"
      ];
      after = [
        "network-online.target"
        "pingvin-share-backend.service"
      ];

      environment = {
        PORT = toString cfg.frontend.port;
        API_URL = "${if cfg.https then "https" else "http"}://${cfg.hostname}";
      };
      path = [ cfg.frontend.package ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${cfg.frontend.package}/node_modules/.bin/next start";
        StateDirectory = mkIf (cfg.dataDir == "/var/lib/pingvin-share") "pingvin-share";
        WorkingDirectory = cfg.frontend.package;
      };
    };

    services.nginx = mkIf cfg.nginx.enable {
      enable = lib.mkDefault true;
      virtualHosts."${cfg.hostname}" = {
        enableACME = cfg.https;
        forceSSL = cfg.https;

        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.frontend.port}";
          recommendedProxySettings = true;
        };
        locations."/api" = {
          proxyPass = "http://localhost:${toString cfg.backend.port}";
          recommendedProxySettings = true;
        };
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ ratcornu ];
    doc = ./pingvin-share.md;
  };
}
