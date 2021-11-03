{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.chatwoot;

  baseCfg = {
    Type = "simple";
    DynamicUser = true;
    User = "chatwoot";

    RuntimeDirectory = "chatwoot";
    RuntimeDirectoryMode = 0775;
    WorkingDirectory = pkgs.chatwoot;
    LogsDirectory = "chatwoot";
    StateDirectory = "chatwoot";
  };

  serviceBase = {
    enable = true;

    requires = ["network.target" "postgresql.service" "redis.service"];
    partOf = ["chatwoot.target"];

    path = pkgs.chatwoot.passthru.extraPath ++ [ pkgs.chatwoot ];

    environment = {
      PORT = toString cfg.port;
      RAILS_ENV = "production";
      NODE_ENV = "production";
      RAILS_LOG_TO_STDOUT = "true";
      HOME = "/run/chatwoot";

      POSTGRES_DATABASE = "chatwoot";
      POSTGRES_USERNAME = "chatwoot";
      POSTGRES_HOST = "";

      REDIS_URL = "redis://localhost:6379";
    } // cfg.settings;

    serviceConfig = baseCfg // {
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

    settings = mkOption {
      type = types.attrs;
      description = ''
        Chatwoot settings

        For documentation see https://github.com/chatwoot/chatwoot/blob/develop/.env.example

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
    services.chatwoot.settings = {
      FRONTEND_URL = cfg.externalUrl;
    };

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

      # those get enabled by setup script aswell
      # see https://github.com/chatwoot/chatwoot/blob/master/deployment/setup_20.04.sh
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      virtualHosts.${cfg.domain} = {
        enableACME = true;

        extraConfig = ''
          underscores_in_headers on;
        '';

        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
          proxyWebsockets = true;

          extraConfig = ''
            proxy_pass_header Authorization;

            proxy_buffering off;
            client_max_body_size 0;
            proxy_read_timeout 36000s;
            proxy_redirect off;
          '';
        };
      };
    };

    systemd.targets.chatwoot = {
      enable = true;
      wants = ["chatwoot-web.service" "chatwoot-worker.service"];
      wantedBy = ["multi-user.target"];
    };

    systemd.services.chatwoot-migrate = serviceBase // {
      enable = true;

      /* preStart = ''
        /run/wrappers/bin/su postgres -s /bin/sh -c "psql -d chatwoot -c 'CREATE EXTENSION IF NOT EXISTS \"pgcrypto\";'"
      ''; */

      script = ''
        FLAG="$STATE_DIRECTORY/has_been_initialized"
        if [ ! -e "$FLAG" ]; then
          export DISABLE_DATABASE_ENVIRONMENT_CHECK=1
          ${pkgs.chatwoot.rubyEnv.wrappedRuby}/bin/bundle exec rake db:environment:set
          ${pkgs.chatwoot.rubyEnv.wrappedRuby}/bin/bundle exec rake db:schema:load
          touch "$FLAG"
        else
        ${pkgs.chatwoot.rubyEnv.wrappedRuby}/bin/bundle exec rake db:migrate
        fi
      '';

      serviceConfig = baseCfg // {
        # ExecStart = "${pkgs.chatwoot.rubyEnv.wrappedRuby}/bin/bundle exec rake db:migrate";
        PermissionsStartOnly = true;
        Type = "oneshot";
      };
    };

    systemd.services.chatwoot-worker = serviceBase // {
      enable = true;
      requires = serviceBase.requires ++ [ "chatwoot-migrate.service" ];
      serviceConfig = serviceBase.serviceConfig // {
        ExecStart = "${pkgs.chatwoot.rubyEnv.wrappedRuby}/bin/bundle exec sidekiq -r ${pkgs.chatwoot} -C ${pkgs.chatwoot}/config/sidekiq.yml";
      };
    };

    systemd.services.chatwoot-web = serviceBase // {
      enable = true;
      requires = serviceBase.requires ++ [ "chatwoot-migrate.service" ];
      serviceConfig = serviceBase.serviceConfig // {
        ExecStart = "${pkgs.chatwoot.rubyEnv.wrappedRuby}/bin/bundle exec rails server -p \"$PORT\" -e \"$RAILS_ENV\"";
        ExecStartPost = "${pkgs.coreutils}/bin/timeout 120 /bin/sh -c 'while ! ${pkgs.curl}/bin/curl \"localhost:${toString cfg.port}\" >/dev/null 2>/dev/null; do sleep 1s; done'";
      };
    };
  };
}
