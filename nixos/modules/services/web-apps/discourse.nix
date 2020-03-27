{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.discourse;
  dataDir = "/var/lib/discourse";
  user = "discourse";
  group = "discourse";
  baseUrl = "${if cfg.web.https then "https" else "http"}://${cfg.hostName}";

  configGenerator = c: concatStrings (flip mapAttrsToList c (key: val: "${key} = ${val}\n"));
  mainConfig = pkgs.writeText "discourse.conf" (configGenerator cfg.settings);

  webConfig = pkgs.writeText "site_settings.yml" (builtins.toJSON cfg.web.settings);

  dcEnv = {
    RAILS_ENV = "production";
    RAILS_ROOT = dataDir;
    UNICORN_WORKERS = toString cfg.web.workers;
  };

  mailEnv = {
    DISCOURSE_API_USER = cfg.mail.apiUser;
    DISCOURSE_API_KEY = cfg.mail.apiKeyFile;
    DISCOURSE_BASE_URL = baseUrl;
  };

  dcServiceConfig = {
    Type = "simple";
    Restart = "always";

    User = user;
    Group = group;

    StateDirectory = "discourse";
    WorkingDirectory = dataDir;
    ProtectHome = true;
    ProtectSystem = "strict";
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
  };

  discourse-bundler = pkgs.stdenv.mkDerivation {
    name = "discourse-bundler";
    buildInputs = [ pkgs.makeWrapper ];
    dontBuild = true;
    dontUnpack = true;
    installPhase = ''
      makeWrapper ${cfg.package.rubyEnv}/bin/bundler $out/bin/discourse-bundler \
        ${concatStrings (mapAttrsToList (name: value: "--set ${name} '${value}' ") dcEnv)} \
        --set PATH '${lib.makeBinPath [ pkgs.coreutils pkgs.procps pkgs.gnugrep pkgs.nodePackages.uglify-js pkgs.which pkgs.brotli pkgs.gzip ]}:$PATH' \
        --run 'cd ${dataDir}'
    '';
  };
in
{
  ###### interface

  options.services.discourse = with types; {
    enable = mkEnableOption "Enable Discourse forum";

    hostName = mkOption {
      type = str;
      description = "Hostname running this forum.";
      example = "forum.example.org";
    };

    package = mkOption {
      type = package;
      description = ''
        Discourse package for the service to use.
      '';
      default = pkgs.discourse;
      defaultText = "pkgs.discourse";
    };

    settings = mkOption {
      type = attrsOf (oneOf [ str int bool ]);
      default = {};
      example = {
        db_connect_timeout = 5;
      };
      description = ''
        Additional Discourse configuration attributes.

        Use to override <link xlink:href="https://github.com/discourse/discourse/blob/master/config/discourse_defaults.conf">Discourse defaults</link>.
      '';
    };

    database = {
      host = mkOption {
        type = nullOr str;
        default = null;
        description = ''
          Database host address.

          Use <literal>null</literal> when using
          <option>services.discourse.database.createLocally</option>.
        '';
      };

      socket = mkOption {
        type = nullOr str;
        default = null;
        description = "UNIX Domain socket to use to connect to database.";
        example = "/run/postgres";
      };

      port = mkOption {
        type = nullOr port;
        default = null;
        description = "Database port. Use <literal>null</literal> for default port.";
      };

      name = mkOption {
        type = str;
        default = "discourse";
        defaultText = ''"discourse"'';
        description = ''
          Database name.
        '';
      };

      user = mkOption {
        type = nullOr str;
        default = user;
        description = "Database user. The system user name is used as a default.";
      };

      passwordFile = mkOption {
        type = nullOr path;
        default = null;
        example = "/run/keys/discourse-dbpassword";
        description = ''
          A file containing the password for <option>services.discourse.database.user</option>.
        '';
      };

      createLocally = mkOption {
        type = bool;
        default = true;
        description = "Whether to create a local database automatically.";
      };
    };

    mail = {
      enable = mkEnableOption "Enable Discourse mail processing";

      package = mkOption {
        type = package;
        description = ''
          Discourse mail-receiver package for the service to use.
        '';
        default = pkgs.discourse-mail-receiver;
        defaultText = "pkgs.discourse-mail-receiver";
      };

      domains = mkOption {
        type = listOf str;
        default = [ ];
        example = literalExample ''
          [ "mail.example.org" ]
        '';
        description = ''
          List of mail server domains this instances handles.

          Defaults to singleton with
          <option>services.discourse.hostName</option>.
        '';
      };

      apiUser = mkOption {
        type = str;
        default = "system";
        description = ''
          User whose identity and permissions will be
          used to make requests to Discourse API.
        '';
      };

      apiKeyFile = mkOption {
        type = path;
        example = "/run/keys/discourse-mailer-api-key";
        description = ''
          The file containing API key which will be used
          to authenticate to Discourse in order to submit mail.
        '';
      };
    };

    web = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable nginx integration";
      };

      https = mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to use HTTPS. When nginx integration is enabled,
          this option forces SSL and enables ACME.
        '';
      };

      settings = mkOption {
        type = attrsOf (oneOf [ str int bool ]);
        default = {};
        example = {
          title = "My Discourse";
          site_description = "Example site";
          short_site_description = "NixOS rocks";
          contact_email = "devnull@example.org";
          contact_url = "http://example.org/contact";
          email_in = true;
        };
        description = ''
          Additional Discourse configuration attributes for web front-end.
          These can be overriden via web interface as well, settings provided
          here are used as defaults.

          Use to override <link xlink:href="https://github.com/discourse/discourse/blob/master/config/site_settings.yml">front-end defaults</link>.
        '';
      };

      workers = mkOption {
        type = ints.unsigned;
        default = 4;
        description = ''
          Number of Unicorn workers to spawn.
        '';
      };
    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.database.createLocally -> cfg.database.user == user;
        message = "services.discourse.database.user must be set to ${user} if services.discourse.database.createLocally is set to true";
      }
      { assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "a password cannot be specified if services.discourse.database.createLocally is set to true";
      }
    ];

    services.discourse.mail.domains = mkDefault (singleton cfg.hostName);

    services.discourse.settings = (mapAttrs (_: v: mkDefault v) {
      hostname = cfg.hostName;
      db_name = cfg.database.name;
    }
    // (optionalAttrs (cfg.database.user != null) {
      db_user = cfg.database.user;
    })
    // (optionalAttrs (cfg.database.socket != null) {
      db_socket = cfg.database.socket;
    })
    // (optionalAttrs cfg.database.createLocally {
      db_socket = "/run/postgresql";
    })
    // (optionalAttrs (cfg.database.host != null) {
      db_host = cfg.database.host;
    }));

    environment.systemPackages = [
      discourse-bundler
    ];

    users.users.${user} = {
      description = "Discourse forum user";
      group = group;
      home = dataDir;
      createHome = false;
      isSystemUser = true;
    };

    users.groups.${group} = {};

    systemd.services.discourse = {
      description = "Discourse forum (rails application)";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "postgresql.service" "redis.service" ];
      requires = [ "discourse-sidekiq.service" ];

      environment = dcEnv;

      path = with pkgs; [
        imagemagick
        coreutils # nice
        procps # ps
      ];

      serviceConfig = dcServiceConfig // {
        TimeoutStartSec = "6min"; # due to discourse-pre
        ExecStart = "${cfg.package}/share/discourse/bin/unicorn -E production -c ${dataDir}/config/unicorn.conf.rb";
        ExecStartPre =
          let
            script = pkgs.writeShellScript "discourse-pre" ''
              set -e

              cp -f ${mainConfig} ${dataDir}/config/discourse.conf
              chown ${user}:${group} ${dataDir}/config/discourse.conf

              ${optionalString (cfg.database.passwordFile != null) ''
                chmod u+w ${dataDir}/config/discourse.conf
                echo -n "db_passwd = " >> ${dataDir}/config/discourse.conf
                cat ${cfg.database.passwordFile} >> ${dataDir}/config/discourse.conf
              ''}

              ${pkgs.yq}/bin/yq -s '.[0] * .[1]' \
                ${dataDir}/config/site_settings.yml \
                ${webConfig} \
                > ${dataDir}/config/site_settings.yml.merged

              mv ${dataDir}/config/site_settings.yml{,.defaults}
              mv ${dataDir}/config/site_settings.yml{.merged,}
              chown ${user}:${group} ${dataDir}/config/site_settings.yml

              ${pkgs.sudo}/bin/sudo -E -u ${user} \
                ${discourse-bundler}/bin/discourse-bundler \
                exec rake db:migrate &> ${dataDir}/log/db-migrate.log \
                || { echo "Migrate returned $?, last lines of migration log:"; tail ${dataDir}/log/db-migrate.log; }

              # HAXXX command above creates this with wrong perms..
              chmod +w ${dataDir}/tmp/ember-rails/*.js || true

              # sadly we need to compile assets in Pre
              # as it requires database connection
              # XXX: assets:precompile needed
              ${pkgs.sudo}/bin/sudo -u ${user} \
                ${discourse-bundler}/bin/discourse-bundler \
                exec rake assets:precompile:css --trace \
                 &> ${dataDir}/log/assets.log || cat ${dataDir}/log/assets.log
            '';
          in
            "!${script}";
      };
    };

    systemd.services.discourse-sidekiq = {
      description = "Discourse job queue";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "discourse.service" ];
      environment = dcEnv;
      path = with pkgs; [
        procps # ps
      ];
      serviceConfig = dcServiceConfig // {
        ExecStart = "${discourse-bundler}/bin/discourse-bundler exec sidekiq";
      };
    };

    services.postgresql = optionalAttrs cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = {
            "DATABASE ${cfg.database.name}" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    # The postgresql module doesn't currently support concepts like
    # objects owners and extensions; for now we tack on what's needed
    # here.
    systemd.services.postgresql.postStart = mkAfter (optionalString cfg.database.createLocally ''
      set -eu

      $PSQL '${cfg.database.name}' -tAc "CREATE EXTENSION IF NOT EXISTS hstore"
      $PSQL '${cfg.database.name}' -tAc "CREATE EXTENSION IF NOT EXISTS pg_trgm"
    '');

    services.redis.enable = mkDefault true;

    services.postfix = mkIf cfg.mail.enable {
      enable = true;

      relayDomains = cfg.mail.domains;
      transport = concatMapStringsSep "\n"
        (dom: "${dom} discourse:") cfg.mail.domains;
      config = {
        smtpd_recipient_restrictions = "check_policy_service unix:private/policy";
      };
      masterConfig = {
        "discourse" = {
          type = "unix";
          privileged = true;
          chroot = false;
          command = "pipe";
          args = [
            "user=nobody:nogroup"
            "argv=${cfg.mail.package}/bin/receive-mail"
            "\${recipient}"
          ];
        };
        "policy" = {
          type = "unix";
          privileged = true;
          chroot = false;
          command = "spawn";
          args = [
            "user=nobody:nogroup"
            "argv=${cfg.mail.package}/bin/discourse-smtp-fast-rejection"
          ];
        };
      };
    };

    systemd.services.postfix.after = optionals
      cfg.mail.enable [ "discourse-mail-init.service" ];

    systemd.services.discourse-mail-init = mkIf cfg.mail.enable {
      wantedBy = [ "multi-user.target" ];
      after = [ "discourse.service" ];

      script = ''
        apiKey="$(<'${cfg.mail.apiKeyFile}')"
        echo '${ builtins.toJSON mailEnv }' | ${pkgs.jq}/bin/jq ".DISCOURSE_API_KEY=\"$apiKey\"" \
          > ${dataDir}/mail-receiver-environment.json

        chown postfix ${dataDir}/mail-receiver-environment.json
        chmod 400 ${dataDir}/mail-receiver-environment.json
      '';
      serviceConfig.Type = "oneshot";
    };

    systemd.tmpfiles.rules = [
      "C  ${dataDir} -    ${user} - - ${cfg.package}/share/discourse"
      "Z  ${dataDir} 0751 ${user} - -"
      "Z  ${dataDir}/public 0751 ${user} nginx -"
    ];

    services.nginx = mkIf (cfg.web.enable) {
      enable = true;
      upstreams.discourse.servers."127.0.0.1:3000" = {};
      virtualHosts.${cfg.hostName} = {
        forceSSL = mkDefault cfg.web.https;
        enableACME = mkDefault cfg.web.https;
        locations = {
          "/" = {
            root = "${dataDir}/public";
            tryFiles = "$uri @discourse";
          };

          "@discourse" = {
            proxyPass = "http://discourse";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Request-Start "t=''${msec}";
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-Host $http_host;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

        };
      };
    };

  };

  meta.maintainers = with maintainers; [ sorki ];
}
