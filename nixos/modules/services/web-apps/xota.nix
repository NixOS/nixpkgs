{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.xota;
  package = pkgs.xota.override {
    inherit (cfg) eventName additionalPatches;
  };
  mkEnv =
    {
      env,
      value,
    }:
    lib.optionalString (value != null) (
      if buildins.isString value then "export ${env}=${value}" else "export ${env}=$( cat ${value})"
    );
in
{

  options.services.xota = with types; {

    enable = mkEnableOption "xOTA";
    dataDir = mkOption {
      type = path;
      default = "/var/lib/xota";
      example = "/vat/lib/xota";
      description = "xOTA data directory.";
    };
    domain = mkOption {
      type = str;
      default = "localhost";
      example = "xota.example.com";
      description = "xOTA domain";
    };
    eventName = mkOption {
      type = str;
      default = "local";
      example = "39C3";
      description = "The Event name at which xOTA will be used";
    };
    settings = {
      enableUserPass = mkEnableOption "Allowes user password registration";
      ccchub = {
        domain = mkOption {
          type = nullOr str;
          default = null;
          example = "https://events.ccc.de/congress/2025/hub";
          description = "The Domain of the cccHub domain to use for cccHub SSO";
        };
        authCallbackURL = mkOption {
          type = nullOr str;
          default = null;
          description = "The callback url of the cccHub";
        };
        clientSecretFile = mkOption {
          type = nullOr path;
          default = null;
          example = "/run/secrets/xota/ccchub/client-secret";
          description = "The path to the file where the client secret for cccHub is stored";
        };
        clientIDFile = mkOption {
          type = nullOr path;
          default = null;
          example = "/run/secrets/xota/ccchub/client-id";
          description = "The path to the file where the client id for cccHub is stored";
        };
        meApi = mkOption {
          type = nullOr str;
          default = null;
          description = "The me api url of the cccHub";
        };
        scope = mkOption {
          type = nullOr str;
          default = null;
          description = "The me scope for the cccHub";
        };
      };
      darcSSO = {
        authCallbackURL = mkOption {
          type = nullOr str;
          default = null;
          description = "The callback url of the DARC SSO";
        };
        clientSecretFile = mkOption {
          type = nullOr path;
          default = null;
          example = "/run/secrets/xota/darc/client-secret";
          description = "The path to the file where the client secret for DARC SSO is stored";
        };
        clientIDFile = mkOption {
          type = nullOr path;
          default = null;
          example = "/run/secrets/xota/darc/client-id";
          description = "The path to the file where the client id for DARC SSO is stored";
        };
      };
    };
    additionalPatches = mkOption {
      type = listOf path;
      default = [ ];
      example = [
        ./39c3.patch
      ];
      description = ''
        Since xOTA requires to configer the Resources and config files before building it.

              You can add aditional patch files here to build the package'';
    };
    port = mkOption {
      type = port;
      default = 8080;
      example = 8443;
      description = "Port on which xOTA listens for incomming conntections";
    };
    listenAddress = mkOption {
      type = str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "The address where xOTA listens for incomming conntections";
    };
  };
  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts.${cfg.domain} = {
        serverName = cfg.domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          recommendedProxySettings = true;
        };
      };
    };
    systemd.services.xota = {
      enable = true;
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      description = "xOTA application";
      script = with cfg.settings; ''
        ln -sf ${package}/Public .
        ln -sf ${package}/Resources .
        ${lib.optionalString enableUserPass "export USER_PASS_ENABLED=1"}
        ${mkEnv {
          env = "CCCHUB_DOMAIN";
          value = ccchub.domain;
        }}
        ${mkEnv {
          env = "CCCHUB_AUTH_CALLBACK";
          value = ccchub.authCallbackURL;
        }}
        ${mkEnv {
          env = "CCCHUB_CLIENT_ID";
          value = ccchub.clientIDFile;
        }}
        ${mkEnv {
          env = "CCCHUB_CLIENT_SECRET";
          value = ccchub.clientSecretFile;
        }}
        ${mkEnv {
          env = "CCCHUB_ME_API";
          value = ccchub.meApi;
        }}
        ${mkEnv {
          env = "CCCHUB_SCOPE";
          value = ccchub.scope;
        }}
        ${mkEnv {
          env = "DARC_SSO_AUTH_CALLBACK";
          value = darcSSO.authCallbackURL;
        }}
        ${mkEnv {
          env = "DARC_SSO_CLIENT_ID";
          value = darcSSO.clientIDFile;
        }}
        ${mkEnv {
          env = "DARC_SSO_CLIENT_SECRET";
          value = darcSSO.clientSecretFile;
        }}
        ${package}/bin/xOTA_App serve --auto-migrate --env production -p ${builtins.toString cfg.port} -H ${cfg.listenAddress}
      '';
      serviceConfig = {
        User = "xota";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        DynamicUser = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        Restart = "always";
        RestartSec = "10s";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        StateDirectory = "xota";
        StateDirectoryMode = "0750";
        WorkingDirectory = cfg.dataDir;
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        SystemCallArchitectures = "native";
      };
    };
  };
  meta.maintainers = pkgs.xota.meta.maintainers;
}
