{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.pingvin-share-x;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  stateDir = "/var/lib/pingvin-share-x";
  dataDir = "${stateDir}/data";

  settingsFormat = pkgs.formats.yaml { };

  backendUrl = "http://${cfg.backend.address}:${toString cfg.backend.port}";

  # Not recommendedProxySettings: X-Forwarded-For must be overwritten, not appended to,
  # or clients could spoof the address seen by the backend's rate limiter.
  proxyHeaders = ''
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;
  '';

  hardening = {
    CapabilityBoundingSet = "";
    LockPersonality = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateIPC = true;
    PrivateTmp = true;
    PrivateUsers = true;
    ProcSubset = "pid";
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    ProtectSystem = "strict";
    RemoveIPC = true;
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
    ];
    UMask = "0077";
  };
in
{
  options.services.pingvin-share-x = {
    enable = mkEnableOption "Pingvin Share X, a self-hosted file sharing platform";

    package = mkPackageOption pkgs "pingvin-share-x" { };

    user = mkOption {
      type = types.str;
      default = "pingvin-share-x";
      description = "User account under which Pingvin Share X runs.";
    };

    group = mkOption {
      type = types.str;
      default = "pingvin-share-x";
      description = "Group under which Pingvin Share X runs.";
    };

    backend = {
      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = "Address the backend listens on.";
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = "Port the backend listens on.";
      };
    };

    frontend = {
      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = "Address the frontend listens on.";
      };

      port = mkOption {
        type = types.port;
        default = 3000;
        description = "Port the frontend listens on.";
      };
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open {option}`services.pingvin-share-x.frontend.port` in the firewall.";
    };

    settings = mkOption {
      type = types.nullOr settingsFormat.type;
      default = null;
      example = lib.literalExpression ''
        {
          general.appUrl = "https://share.example.com";
          share.maxSize = "10000000000";
        }
      '';
      description = ''
        Configuration written to `config.yaml`, see
        <https://github.com/smp46/pingvin-share-x/blob/main/config.example.yaml>.
        When set, these values override the ones stored in the database and the admin UI becomes
        read-only as a whole. The file is world-readable in the Nix store; use
        {option}`services.pingvin-share-x.configFile` for secrets such as SMTP or OIDC credentials.
        When both are `null`, configuration is done through the admin UI.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default =
        if cfg.settings == null then
          null
        else
          settingsFormat.generate "config.yaml" (
            lib.recursiveUpdate { initUser.enabled = false; } cfg.settings
          );
      defaultText = lib.literalMD "generated from {option}`services.pingvin-share-x.settings`";
      description = ''
        Path to a `config.yaml`, read at runtime by the backend. Point it at a file outside the
        Nix store to keep SMTP or OIDC credentials secret. It must set `initUser.enabled`, the
        backend fails to start otherwise.
      '';
    };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        CLAMAV_HOST = "127.0.0.1";
        PV_LOG_LEVEL = "debug";
      };
      description = "Extra environment variables for the backend.";
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Environment file passed to the backend, for values that must not land in the Nix store.";
    };

    trustProxy = mkOption {
      type = types.bool;
      default = cfg.nginx.enable;
      defaultText = lib.literalExpression "config.services.pingvin-share-x.nginx.enable";
      description = ''
        Whether to trust `X-Forwarded-*` headers set by a reverse proxy. The Nginx virtual host
        overwrites `X-Forwarded-For` with `$remote_addr`, so clients cannot spoof the address the
        rate limiter sees; configure the realip module when another proxy sits in front of Nginx.
      '';
    };

    nginx = {
      enable = mkEnableOption "an Nginx virtual host for Pingvin Share X";

      hostName = mkOption {
        type = types.str;
        example = "share.example.com";
        description = "Name of the Nginx virtual host.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users = mkIf (cfg.user == "pingvin-share-x") {
      pingvin-share-x = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "pingvin-share-x") { pingvin-share-x = { }; };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.frontend.port ];

    systemd.services.pingvin-share-x-backend = {
      description = "Pingvin Share X backend";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        BACKEND_HOST = cfg.backend.address;
        BACKEND_PORT = toString cfg.backend.port;
        DATABASE_URL = "file:${dataDir}/pingvin-share.db?connection_limit=1";
        DATA_DIRECTORY = dataDir;
        TRUST_PROXY = lib.boolToString cfg.trustProxy;
      }
      // lib.optionalAttrs (cfg.configFile != null) { CONFIG_FILE = toString cfg.configFile; }
      // cfg.environment;

      preStart = ''
        mkdir -p ${dataDir} ${cfg.package.imagesDir}
        cp -rn --no-preserve=mode ${cfg.package.frontend}/img/. ${cfg.package.imagesDir}/
        ${lib.getExe' cfg.package "pingvin-share-x-migrate"}
        ${lib.getExe' cfg.package "pingvin-share-x-seed"}
      '';

      serviceConfig = hardening // {
        ExecStart = lib.getExe' cfg.package "pingvin-share-x-backend";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
        StateDirectory = "pingvin-share-x";
        StateDirectoryMode = "0750";
        WorkingDirectory = stateDir;
        Restart = "on-failure";
      };
    };

    systemd.services.pingvin-share-x-frontend = {
      description = "Pingvin Share X frontend";
      after = [ "pingvin-share-x-backend.service" ];
      requires = [ "pingvin-share-x-backend.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        API_URL = backendUrl;
        HOSTNAME = cfg.frontend.address;
        PORT = toString cfg.frontend.port;
      };

      serviceConfig = hardening // {
        ExecStart = lib.getExe' cfg.package "pingvin-share-x-frontend";
        User = cfg.user;
        Group = cfg.group;
        ReadOnlyPaths = [ stateDir ];
        Restart = "on-failure";
      };
    };

    services.nginx = mkIf cfg.nginx.enable {
      enable = true;
      virtualHosts.${cfg.nginx.hostName} = {
        locations."/" = {
          proxyPass = "http://${cfg.frontend.address}:${toString cfg.frontend.port}";
          extraConfig = proxyHeaders;
        };
        locations."/api/" = {
          proxyPass = backendUrl;
          extraConfig = proxyHeaders + ''
            client_max_body_size 0;
            proxy_request_buffering off;
          '';
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ znaniye ];
}
