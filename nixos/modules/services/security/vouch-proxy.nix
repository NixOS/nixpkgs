{ config, pkgs, lib, ... }:

let
  cfg = config.services.vouch-proxy;

  yaml = pkgs.formats.yaml { };
  configFile = yaml.generate "vouch-proxy-config.yaml" cfg.settings;
in
{
  options.services.vouch-proxy = {
    enable = lib.mkEnableOption "vouch-proxy";

    package = lib.mkPackageOption pkgs "vouch-proxy" { };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = lib.mdDoc ''
        Environment file as defined in {manpage}`systemd.exec(5)`.
      '';
      example = "/run/keys/vouch-proxy";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open ports in the firewall for vouch-proxy.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = yaml.type;

        options = {
          vouch = {
            listen = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1";
              description = "Hostname or IP to listen on.";
              example = "[::1]";
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 9090;
              description = "HTTP port to listen on.";
            };
          };
        };
      };
      default = { };
      description = lib.mdDoc ''
        Attrset that is converted and passed as config file.
        Available options can be found
        [here](https://github.com/vouch/vouch-proxy/blob/master/config/config.yml_example).

        Secret values can be passed through the
        [](#opt-services.vouch-proxy.environmentFile).
      '';
      example = lib.literalExpression ''
        {
            vouch = {
              listen = "127.0.0.1";
              port = 9090;
              allowAllUsers = true;
              cookie.secure = true;
              cookie.domain = "mydomain.tld";
            };

            oauth = {
              provider = "oidc";
              client_id = "my_client_id";
              auth_url = "https://sso.mydomain.tld/realms/myrealm/protocol/openid-connect/auth";
              token_url = "https://sso.mydomain.tld/realms/myrealm/protocol/openid-connect/token";
              user_info_url = "https://sso.mydomain.tld/realms/myrealm/protocol/openid-connect/userinfo";
              scopes = [ "openid" "email" "profile" ];
              callback_url = "https://vouch.mydoamin.tld/auth";
              code_challenge_method = "S256";
            };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.vouch-proxy = {
      description = "Vouch Proxy";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "idle";
        KillSignal = "SIGINT";
        ExecStart = "${cfg.package}/bin/vouch-proxy -config ${configFile}";
        Restart = "on-failure";
        RestartSec = 5;
        StartLimitBurst = 3;

        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];

        # hardening
        DynamicUser = true;
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        SystemCallErrorNumber = "EPERM";
        ProtectProc = "invisible";
        ProtectHostname = true;
        ProcSubset = "pid";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.vouch.port ];
    };
  };

  meta.maintainers = with lib.maintainers; [ newam ];
}
