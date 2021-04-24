{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.chatwoot;
  serviceBase = {
    enable = true;

    requires = ["network.target" "postgresql.service" "redis.service"];
    # wants = ["postgres.service"];
    partOf = ["chatwoot.target"];

    path = pkgs.chatwoot.passthru.extraPath;

    environment = {
      PORT = toString cfg.port;
      RAILS_ENV = "production";
      NODE_ENV = "production";
      RAILS_LOG_TO_STDOUT = "true";
      FRONTEND_URL = cfg.externalUrl;
      HOME = "/run/chatwoot";

      POSTGRES_DATABASE = "chatwoot";
      POSTGRES_USERNAME = "chatwoot";
      POSTGRES_HOST = "";

      REDIS_URL = "redis://localhost:6379";
    } // cfg.extraConfig;

    serviceConfig = {
      Type = "simple";
      DynamicUser = true;
      User = "chatwoot";

      RuntimeDirectory = "chatwoot";
      RuntimeDirectoryMode = 0775;
      WorkingDirectory = pkgs.chatwoot;
      LogDirectory = "chatwoot";
      StateDirectory = "chatwoot";

      Restart = "always";
      RestartSec = 1;
      TimeoutStopSec = 30;
      KillMode = "mixed";
      StandartInput = null;
      SyslogIdentifier = "%p";
    };
  };
in
{
  options.services.chatwoot = {
    enable = mkEnableOption "chatwoot";

    externalUrl = mkOption {
      type = types.str;
      description = "URL over which chatwoot will be accessed";
      default = "https://${cfg.domain}";
    };

    domain = mkOption {
      type = types.str;
      description = "Domain under which to run chatwoot";
    };

    port = mkOption {
      description = "Port to listen at";
      type = types.port;
      default = 3000;
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open ports in the firewall for chatwoot.";
    };

    extraConfig = mkOption {
      type = types.attrs;
      description = ''
        Extra config options

        See https://github.com/chatwoot/chatwoot/blob/develop/.env.example

        Example
        <literal>{
          ENABLE_ACCOUNT_SIGNUP = true;
          MAILER_SENDER_EMAIL = "YourCompany &lt;no-reply@company.tld&gt;";
        }</literal>
        '';
      default = {};
    };

    nginx = mkEnableOption "chatwoot nginx configuration";
  };

  config = mkIf (cfg.enable) {
    services.chatwoot.domain = mkDefault "https://${cfg.domain}";

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    services.redis = {
      enable = true;
    };

    services.postgresql = {
      enable = true;
      ensureUsers = [{
        name = "chatwoot";
        ensurePermissions = { "DATABASE chatwoot" = "ALL PRIVILEGES"; };
      }];
      ensureDatabases = [ "chatwoot" ];
    };

    services.nginx = mkIf (cfg.nginx) {
      enable = true;

      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      virtualHosts.${cfg.domain} = {
        enableACME = true;

        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
          proxyWebsockets = true;
        };
      };
    };

    systemd.targets.chatwoot = {
      enable = true;
      wants = ["chatwoot-web.service" "chatwoot-worker.service"];
      wantedBy = ["multi-user.target"];
    };

    systemd.services.chatwoot-worker = serviceBase // {
      enable = true;
      serviceConfig = serviceBase.serviceConfig // {
        ExecStart = "${pkgs.chatwoot.rubyEnv}/bin/bundle exec sidekiq -r ${pkgs.chatwoot} -C ${pkgs.chatwoot}/config/sidekiq.yml";
      };
    };

    systemd.services.chatwoot-web = serviceBase // {
      enable = true;
      serviceConfig = serviceBase.serviceConfig // {
        ExecStart = "${pkgs.chatwoot.rubyEnv}/bin/rails server -p \"$PORT\" -e \"$RAILS_ENV\"";
        ExecStartPost = "${pkgs.coreutils}/bin/timeout 120 /bin/sh -c 'while ! ${pkgs.curl}/bin/curl \"localhost:${toString cfg.port}\" >/dev/null 2>/dev/null; do sleep 1s; done'";
      };
    };
  };
}
