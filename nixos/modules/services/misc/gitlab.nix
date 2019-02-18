{ config, lib, pkgs, ... }:

# TODO: support non-postgresql

with lib;

let
  cfg = config.services.gitlab;

  ruby = cfg.packages.gitlab.ruby;

  gitlabSocket = "${cfg.statePath}/tmp/sockets/gitlab.socket";
  gitalySocket = "${cfg.statePath}/tmp/sockets/gitaly.socket";
  pathUrlQuote = url: replaceStrings ["/"] ["%2F"] url;
  pgSuperUser = config.services.postgresql.superUser;

  databaseConfig = {
    production = {
      adapter = "postgresql";
      database = cfg.databaseName;
      host = cfg.databaseHost;
      password = cfg.databasePassword;
      username = cfg.databaseUsername;
      encoding = "utf8";
    };
  };

  gitalyToml = pkgs.writeText "gitaly.toml" ''
    socket_path = "${lib.escape ["\""] gitalySocket}"
    bin_dir = "${cfg.packages.gitaly}/bin"
    prometheus_listen_addr = "localhost:9236"

    [git]
    bin_path = "${pkgs.git}/bin/git"

    [gitaly-ruby]
    dir = "${cfg.packages.gitaly.ruby}"

    [gitlab-shell]
    dir = "${cfg.packages.gitlab-shell}"

    ${concatStringsSep "\n" (attrValues (mapAttrs (k: v: ''
    [[storage]]
    name = "${lib.escape ["\""] k}"
    path = "${lib.escape ["\""] v.path}"
    '') gitlabConfig.production.repositories.storages))}
  '';

  gitlabShellConfig = {
    user = cfg.user;
    gitlab_url = "http+unix://${pathUrlQuote gitlabSocket}";
    http_settings.self_signed_cert = false;
    repos_path = "${cfg.statePath}/repositories";
    secret_file = "${cfg.statePath}/config/gitlab_shell_secret";
    log_file = "${cfg.statePath}/log/gitlab-shell.log";
    custom_hooks_dir = "${cfg.statePath}/custom_hooks";
    redis = {
      bin = "${pkgs.redis}/bin/redis-cli";
      host = "127.0.0.1";
      port = 6379;
      database = 0;
      namespace = "resque:gitlab";
    };
  };

  redisConfig.production.url = "redis://localhost:6379/";

  secretsConfig.production = {
    secret_key_base = cfg.secrets.secret;
    otp_key_base = cfg.secrets.otp;
    db_key_base = cfg.secrets.db;
    openid_connect_signing_key = cfg.secrets.jws;
  };

  gitlabConfig = {
    # These are the default settings from config/gitlab.example.yml
    production = flip recursiveUpdate cfg.extraConfig {
      gitlab = {
        host = cfg.host;
        port = cfg.port;
        https = cfg.https;
        user = cfg.user;
        email_enabled = true;
        email_display_name = "GitLab";
        email_reply_to = "noreply@localhost";
        default_theme = 2;
        default_projects_features = {
          issues = true;
          merge_requests = true;
          wiki = true;
          snippets = true;
          builds = true;
          container_registry = true;
        };
      };
      repositories.storages.default.path = "${cfg.statePath}/repositories";
      repositories.storages.default.gitaly_address = "unix:${gitalySocket}";
      artifacts.enabled = true;
      lfs.enabled = true;
      gravatar.enabled = true;
      cron_jobs = { };
      gitlab_ci.builds_path = "${cfg.statePath}/builds";
      ldap.enabled = false;
      omniauth.enabled = false;
      shared.path = "${cfg.statePath}/shared";
      gitaly.client_path = "${cfg.packages.gitaly}/bin";
      backup.path = "${cfg.backupPath}";
      gitlab_shell = {
        path = "${cfg.packages.gitlab-shell}";
        hooks_path = "${cfg.statePath}/shell/hooks";
        secret_file = "${cfg.statePath}/config/gitlab_shell_secret";
        upload_pack = true;
        receive_pack = true;
      };
      workhorse.secret_file = "${cfg.statePath}/.gitlab_workhorse_secret";
      git.bin_path = "git";
      monitoring = {
        ip_whitelist = [ "127.0.0.0/8" "::1/128" ];
        sidekiq_exporter = {
          enable = true;
          address = "localhost";
          port = 3807;
        };
      };
      extra = {};
      uploads.storage_path = cfg.statePath;
    };
  };

  gitlabEnv = {
    HOME = "${cfg.statePath}/home";
    UNICORN_PATH = "${cfg.statePath}/";
    GITLAB_PATH = "${cfg.packages.gitlab}/share/gitlab/";
    GITLAB_STATE_PATH = cfg.statePath;
    GITLAB_UPLOADS_PATH = "${cfg.statePath}/uploads";
    SCHEMA = "${cfg.statePath}/db/schema.rb";
    GITLAB_LOG_PATH = "${cfg.statePath}/log";
    GITLAB_SHELL_PATH = "${cfg.packages.gitlab-shell}";
    GITLAB_SHELL_CONFIG_PATH = "${cfg.statePath}/shell/config.yml";
    GITLAB_SHELL_SECRET_PATH = "${cfg.statePath}/config/gitlab_shell_secret";
    GITLAB_SHELL_HOOKS_PATH = "${cfg.statePath}/shell/hooks";
    GITLAB_REDIS_CONFIG_FILE = pkgs.writeText "redis.yml" (builtins.toJSON redisConfig);
    prometheus_multiproc_dir = "/run/gitlab";
    RAILS_ENV = "production";
  };

  gitlab-rake = pkgs.stdenv.mkDerivation rec {
    name = "gitlab-rake";
    buildInputs = [ pkgs.makeWrapper ];
    dontBuild = true;
    unpackPhase = ":";
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${cfg.packages.gitlab.rubyEnv}/bin/rake $out/bin/gitlab-rake \
          ${concatStrings (mapAttrsToList (name: value: "--set ${name} '${value}' ") gitlabEnv)} \
          --set PATH '${lib.makeBinPath [ pkgs.nodejs pkgs.gzip pkgs.git pkgs.gnutar config.services.postgresql.package pkgs.coreutils pkgs.procps ]}:$PATH' \
          --set RAKEOPT '-f ${cfg.packages.gitlab}/share/gitlab/Rakefile' \
          --run 'cd ${cfg.packages.gitlab}/share/gitlab'
     '';
  };

  smtpSettings = pkgs.writeText "gitlab-smtp-settings.rb" ''
    if Rails.env.production?
      Rails.application.config.action_mailer.delivery_method = :smtp

      ActionMailer::Base.delivery_method = :smtp
      ActionMailer::Base.smtp_settings = {
        address: "${cfg.smtp.address}",
        port: ${toString cfg.smtp.port},
        ${optionalString (cfg.smtp.username != null) ''user_name: "${cfg.smtp.username}",''}
        ${optionalString (cfg.smtp.password != null) ''password: "${cfg.smtp.password}",''}
        domain: "${cfg.smtp.domain}",
        ${optionalString (cfg.smtp.authentication != null) "authentication: :${cfg.smtp.authentication},"}
        enable_starttls_auto: ${toString cfg.smtp.enableStartTLSAuto},
        openssl_verify_mode: '${cfg.smtp.opensslVerifyMode}'
      }
    end
  '';

in {

  options = {
    services.gitlab = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the gitlab service.
        '';
      };

      packages.gitlab = mkOption {
        type = types.package;
        default = pkgs.gitlab;
        defaultText = "pkgs.gitlab";
        description = "Reference to the gitlab package";
        example = "pkgs.gitlab-ee";
      };

      packages.gitlab-shell = mkOption {
        type = types.package;
        default = pkgs.gitlab-shell;
        defaultText = "pkgs.gitlab-shell";
        description = "Reference to the gitlab-shell package";
      };

      packages.gitlab-workhorse = mkOption {
        type = types.package;
        default = pkgs.gitlab-workhorse;
        defaultText = "pkgs.gitlab-workhorse";
        description = "Reference to the gitlab-workhorse package";
      };

      packages.gitaly = mkOption {
        type = types.package;
        default = pkgs.gitaly;
        defaultText = "pkgs.gitaly";
        description = "Reference to the gitaly package";
      };

      statePath = mkOption {
        type = types.str;
        default = "/var/gitlab/state";
        description = "Gitlab state directory, logs are stored here.";
      };

      backupPath = mkOption {
        type = types.str;
        default = cfg.statePath + "/backup";
        description = "Gitlab path for backups.";
      };

      databaseHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Gitlab database hostname.";
      };

      databasePassword = mkOption {
        type = types.str;
        description = "Gitlab database user password.";
      };

      databaseName = mkOption {
        type = types.str;
        default = "gitlab";
        description = "Gitlab database name.";
      };

      databaseUsername = mkOption {
        type = types.str;
        default = "gitlab";
        description = "Gitlab database user.";
      };

      host = mkOption {
        type = types.str;
        default = config.networking.hostName;
        description = "Gitlab host name. Used e.g. for copy-paste URLs.";
      };

      port = mkOption {
        type = types.int;
        default = 8080;
        description = ''
          Gitlab server port for copy-paste URLs, e.g. 80 or 443 if you're
          service over https.
        '';
      };

      https = mkOption {
        type = types.bool;
        default = false;
        description = "Whether gitlab prints URLs with https as scheme.";
      };

      user = mkOption {
        type = types.str;
        default = "gitlab";
        description = "User to run gitlab and all related services.";
      };

      group = mkOption {
        type = types.str;
        default = "gitlab";
        description = "Group to run gitlab and all related services.";
      };

      initialRootEmail = mkOption {
        type = types.str;
        default = "admin@local.host";
        description = ''
          Initial email address of the root account if this is a new install.
        '';
      };

      initialRootPassword = mkOption {
        type = types.str;
        description = ''
          Initial password of the root account if this is a new install.
        '';
      };

      smtp = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable gitlab mail delivery over SMTP.";
        };

        address = mkOption {
          type = types.str;
          default = "localhost";
          description = "Address of the SMTP server for Gitlab.";
        };

        port = mkOption {
          type = types.int;
          default = 465;
          description = "Port of the SMTP server for Gitlab.";
        };

        username = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Username of the SMTP server for Gitlab.";
        };

        password = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Password of the SMTP server for Gitlab.";
        };

        domain = mkOption {
          type = types.str;
          default = "localhost";
          description = "HELO domain to use for outgoing mail.";
        };

        authentication = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Authentitcation type to use, see http://api.rubyonrails.org/classes/ActionMailer/Base.html";
        };

        enableStartTLSAuto = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to try to use StartTLS.";
        };

        opensslVerifyMode = mkOption {
          type = types.str;
          default = "peer";
          description = "How OpenSSL checks the certificate, see http://api.rubyonrails.org/classes/ActionMailer/Base.html";
        };
      };

      secrets.secret = mkOption {
        type = types.str;
        description = ''
          The secret is used to encrypt variables in the DB. If
          you change or lose this key you will be unable to access variables
          stored in database.

          Make sure the secret is at least 30 characters and all random,
          no regular words or you'll be exposed to dictionary attacks.
        '';
      };

      secrets.db = mkOption {
        type = types.str;
        description = ''
          The secret is used to encrypt variables in the DB. If
          you change or lose this key you will be unable to access variables
          stored in database.

          Make sure the secret is at least 30 characters and all random,
          no regular words or you'll be exposed to dictionary attacks.
        '';
      };

      secrets.otp = mkOption {
        type = types.str;
        description = ''
          The secret is used to encrypt secrets for OTP tokens. If
          you change or lose this key, users which have 2FA enabled for login
          won't be able to login anymore.

          Make sure the secret is at least 30 characters and all random,
          no regular words or you'll be exposed to dictionary attacks.
        '';
      };

      secrets.jws = mkOption {
        type = types.str;
        description = ''
          The secret is used to encrypt session keys. If you change or lose
          this key, users will be disconnected.

          Make sure the secret is an RSA private key in PEM format. You can
          generate one with

          openssl genrsa 2048
        '';
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        example = {
          gitlab = {
            default_projects_features = {
              builds = false;
            };
          };
        };
        description = ''
          Extra options to be merged into config/gitlab.yml as nix
          attribute set.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.git gitlab-rake cfg.packages.gitlab-shell ];

    # Redis is required for the sidekiq queue runner.
    services.redis.enable = mkDefault true;
    # We use postgres as the main data store.
    services.postgresql.enable = mkDefault true;
    # Use postfix to send out mails.
    services.postfix.enable = mkDefault true;

    users.users = [
      { name = cfg.user;
        group = cfg.group;
        home = "${cfg.statePath}/home";
        shell = "${pkgs.bash}/bin/bash";
        uid = config.ids.uids.gitlab;
      }
    ];

    users.groups = [
      { name = cfg.group;
        gid = config.ids.gids.gitlab;
      }
    ];

    systemd.tmpfiles.rules = [
      "d /run/gitlab 0755 ${cfg.user} ${cfg.group} -"
      "d ${gitlabEnv.HOME} 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.backupPath} 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/builds 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/config 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/db 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/log 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/repositories 2770 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/shell 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/tmp/pids 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/tmp/sockets 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/uploads 0700 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/custom_hooks/pre-receive.d 0700 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/custom_hooks/post-receive.d 0700 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/custom_hooks/update.d 0700 ${cfg.user} ${cfg.group} -"
      "d ${gitlabConfig.production.shared.path}/artifacts 0750 ${cfg.user} ${cfg.group} -"
      "d ${gitlabConfig.production.shared.path}/lfs-objects 0750 ${cfg.user} ${cfg.group} -"
      "d ${gitlabConfig.production.shared.path}/pages 0750 ${cfg.user} ${cfg.group} -"
    ];

    systemd.services.gitlab-sidekiq = {
      after = [ "network.target" "redis.service" "gitlab.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = gitlabEnv;
      path = with pkgs; [
        config.services.postgresql.package
        gitAndTools.git
        ruby
        openssh
        nodejs
        gnupg
      ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "infinity";
        Restart = "on-failure";
        WorkingDirectory = "${cfg.packages.gitlab}/share/gitlab";
        ExecStart="${cfg.packages.gitlab.rubyEnv}/bin/sidekiq -C \"${cfg.packages.gitlab}/share/gitlab/config/sidekiq_queues.yml\" -e production -P ${cfg.statePath}/tmp/sidekiq.pid";
      };
    };

    systemd.services.gitaly = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        openssh
        gitAndTools.git
        cfg.packages.gitaly.rubyEnv
        cfg.packages.gitaly.rubyEnv.wrappedRuby
      ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "infinity";
        Restart = "on-failure";
        WorkingDirectory = gitlabEnv.HOME;
        ExecStart = "${cfg.packages.gitaly}/bin/gitaly ${gitalyToml}";
      };
    };

    systemd.services.gitlab-workhorse = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        gitAndTools.git
        gnutar
        gzip
        openssh
        gitlab-workhorse
      ];
      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "infinity";
        Restart = "on-failure";
        WorkingDirectory = gitlabEnv.HOME;
        ExecStart =
          "${cfg.packages.gitlab-workhorse}/bin/gitlab-workhorse "
          + "-listenUmask 0 "
          + "-listenNetwork unix "
          + "-listenAddr /run/gitlab/gitlab-workhorse.socket "
          + "-authSocket ${gitlabSocket} "
          + "-documentRoot ${cfg.packages.gitlab}/share/gitlab/public "
          + "-secretPath ${cfg.statePath}/.gitlab_workhorse_secret";
      };
    };

    systemd.services.gitlab = {
      after = [ "gitlab-workhorse.service" "gitaly.service" "network.target" "postgresql.service" "redis.service" ];
      requires = [ "gitlab-sidekiq.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = gitlabEnv;
      path = with pkgs; [
        config.services.postgresql.package
        gitAndTools.git
        openssh
        nodejs
        procps
        gnupg
      ];
      preStart = ''
        cp -rf ${cfg.packages.gitlab}/share/gitlab/db/* ${cfg.statePath}/db
        rm -rf ${cfg.statePath}/config
        mkdir ${cfg.statePath}/config
        if [ -e ${cfg.statePath}/lib ]; then
          rm ${cfg.statePath}/lib
        fi

        ln -sf ${cfg.packages.gitlab}/share/gitlab/lib ${cfg.statePath}/lib
        [ -L /run/gitlab/config ] || ln -sf ${cfg.statePath}/config /run/gitlab/config
        [ -L /run/gitlab/log ] || ln -sf ${cfg.statePath}/log /run/gitlab/log
        [ -L /run/gitlab/tmp ] || ln -sf ${cfg.statePath}/tmp /run/gitlab/tmp
        [ -L /run/gitlab/uploads ] || ln -sf ${cfg.statePath}/uploads /run/gitlab/uploads
        cp ${cfg.packages.gitlab}/share/gitlab/VERSION ${cfg.statePath}/VERSION
        cp -rf ${cfg.packages.gitlab}/share/gitlab/config.dist/* ${cfg.statePath}/config
        ${optionalString cfg.smtp.enable ''
          ln -sf ${smtpSettings} ${cfg.statePath}/config/initializers/smtp_settings.rb
        ''}
        ${pkgs.openssl}/bin/openssl rand -hex 32 > ${cfg.statePath}/config/gitlab_shell_secret

        # JSON is a subset of YAML
        ln -sf ${pkgs.writeText "gitlab.yml" (builtins.toJSON gitlabConfig)} ${cfg.statePath}/config/gitlab.yml
        ln -sf ${pkgs.writeText "database.yml" (builtins.toJSON databaseConfig)} ${cfg.statePath}/config/database.yml
        ln -sf ${pkgs.writeText "secrets.yml" (builtins.toJSON secretsConfig)} ${cfg.statePath}/config/secrets.yml
        ln -sf ${./defaultUnicornConfig.rb} ${cfg.statePath}/config/unicorn.rb

        # Install the shell required to push repositories
        ln -sf ${pkgs.writeText "config.yml" (builtins.toJSON gitlabShellConfig)} /run/gitlab/shell-config.yml
        [ -L ${cfg.statePath}/shell/hooks ] ||  ln -sf ${cfg.packages.gitlab-shell}/hooks ${cfg.statePath}/shell/hooks
        ${cfg.packages.gitlab-shell}/bin/install

        chown -R ${cfg.user}:${cfg.group} ${cfg.statePath}/
        chmod -R ug+rwX,o-rwx+X ${cfg.statePath}/
        chown -R ${cfg.user}:${cfg.group} /run/gitlab

        if ! test -e "${cfg.statePath}/db-created"; then
          if [ "${cfg.databaseHost}" = "127.0.0.1" ]; then
            ${pkgs.sudo}/bin/sudo -u ${pgSuperUser} psql postgres -c "CREATE ROLE ${cfg.databaseUsername} WITH LOGIN NOCREATEDB NOCREATEROLE ENCRYPTED PASSWORD '${cfg.databasePassword}'"
            ${pkgs.sudo}/bin/sudo -u ${pgSuperUser} ${config.services.postgresql.package}/bin/createdb --owner ${cfg.databaseUsername} ${cfg.databaseName}

            # enable required pg_trgm extension for gitlab
            ${pkgs.sudo}/bin/sudo -u ${pgSuperUser} psql ${cfg.databaseName} -c "CREATE EXTENSION IF NOT EXISTS pg_trgm"
          fi

          ${pkgs.sudo}/bin/sudo -u ${cfg.user} -H ${gitlab-rake}/bin/gitlab-rake db:schema:load

          touch "${cfg.statePath}/db-created"
        fi

        # Always do the db migrations just to be sure the database is up-to-date
        ${pkgs.sudo}/bin/sudo -u ${cfg.user} -H ${gitlab-rake}/bin/gitlab-rake db:migrate

        if ! test -e "${cfg.statePath}/db-seeded"; then
          ${pkgs.sudo}/bin/sudo -u ${cfg.user} ${gitlab-rake}/bin/gitlab-rake db:seed_fu \
            GITLAB_ROOT_PASSWORD='${cfg.initialRootPassword}' GITLAB_ROOT_EMAIL='${cfg.initialRootEmail}'
          touch "${cfg.statePath}/db-seeded"
        fi

        # The gitlab:shell:create_hooks task seems broken for fixing links
        # so we instead delete all the hooks and create them anew
        rm -f ${cfg.statePath}/repositories/**/*.git/hooks
        ${pkgs.sudo}/bin/sudo -u ${cfg.user} -H ${gitlab-rake}/bin/gitlab-rake gitlab:shell:create_hooks

        ${pkgs.sudo}/bin/sudo -u ${cfg.user} -H ${pkgs.git}/bin/git config --global core.autocrlf "input"

        # Change permissions in the last step because some of the
        # intermediary scripts like to create directories as root.
        chmod -R u+rwX,go-rwx+X ${gitlabEnv.HOME}
        chmod -R ug+rwX,o-rwx ${cfg.statePath}/repositories
        chmod -R ug-s ${cfg.statePath}/repositories
        find ${cfg.statePath}/repositories -type d -print0 | xargs -0 chmod g+s
      '';

      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "infinity";
        Restart = "on-failure";
        WorkingDirectory = "${cfg.packages.gitlab}/share/gitlab";
        ExecStart = "${cfg.packages.gitlab.rubyEnv}/bin/unicorn -c ${cfg.statePath}/config/unicorn.rb -E production";
      };

    };

  };

  meta.doc = ./gitlab.xml;

}
