{ config, lib, pkgs, ... }:

# TODO: support non-postgresql

with lib;

let
  cfg = config.services.gitlab;

  ruby = cfg.packages.gitlab.ruby;
  bundler = pkgs.bundler;

  gemHome = "${cfg.packages.gitlab.env}/${ruby.gemPath}";

  gitlabSocket = "${cfg.statePath}/tmp/sockets/gitlab.socket";
  pathUrlQuote = url: replaceStrings ["/"] ["%2F"] url;

  databaseYml = ''
    production:
      adapter: postgresql
      database: ${cfg.databaseName}
      host: ${cfg.databaseHost}
      password: ${cfg.databasePassword}
      username: ${cfg.databaseUsername}
      encoding: utf8
  '';

  gitlabShellYml = ''
    user: ${cfg.user}
    gitlab_url: "http+unix://${pathUrlQuote gitlabSocket}"
    http_settings:
      self_signed_cert: false
    repos_path: "${cfg.statePath}/repositories"
    secret_file: "${cfg.statePath}/config/gitlab_shell_secret"
    log_file: "${cfg.statePath}/log/gitlab-shell.log"
    redis:
      bin: ${pkgs.redis}/bin/redis-cli
      host: 127.0.0.1
      port: 6379
      database: 0
      namespace: resque:gitlab
  '';

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
          snippets = false;
          builds = true;
        };
      };
      artifacts = {
        enabled = true;
      };
      lfs = {
        enabled = true;
      };
      gravatar = {
        enabled = true;
      };
      cron_jobs = {
        stuck_ci_builds_worker = {
          cron = "0 0 * * *";
        };
      };
      gitlab_ci = {
        builds_path = "${cfg.statePath}/builds";
      };
      ldap = {
        enabled = false;
      };
      omniauth = {
        enabled = false;
      };
      shared = {
        path = "${cfg.statePath}/shared";
      };
      backup = {
        path = "${cfg.backupPath}";
      };
      gitlab_shell = {
        path = "${cfg.packages.gitlab-shell}";
        repos_path = "${cfg.statePath}/repositories";
        hooks_path = "${cfg.statePath}/shell/hooks";
        secret_file = "${cfg.statePath}/config/gitlab_shell_secret";
        upload_pack = true;
        receive_pack = true;
      };
      git = {
        bin_path = "git";
        max_size = 20971520; # 20MB
        timeout = 10;
      };
      extra = {};
    };
  };

  gitlabEnv = {
    HOME = "${cfg.statePath}/home";
    GEM_HOME = gemHome;
    BUNDLE_GEMFILE = "${cfg.packages.gitlab}/share/gitlab/Gemfile";
    UNICORN_PATH = "${cfg.statePath}/";
    GITLAB_PATH = "${cfg.packages.gitlab}/share/gitlab/";
    GITLAB_STATE_PATH = "${cfg.statePath}";
    GITLAB_UPLOADS_PATH = "${cfg.statePath}/uploads";
    GITLAB_LOG_PATH = "${cfg.statePath}/log";
    GITLAB_SHELL_PATH = "${cfg.packages.gitlab-shell}";
    GITLAB_SHELL_CONFIG_PATH = "${cfg.statePath}/shell/config.yml";
    GITLAB_SHELL_SECRET_PATH = "${cfg.statePath}/config/gitlab_shell_secret";
    GITLAB_SHELL_HOOKS_PATH = "${cfg.statePath}/shell/hooks";
    RAILS_ENV = "production";
  };

  unicornConfig = builtins.readFile ./defaultUnicornConfig.rb;

  gitlab-runner = pkgs.stdenv.mkDerivation rec {
    name = "gitlab-runner";
    buildInputs = [ cfg.packages.gitlab bundler pkgs.makeWrapper ];
    phases = "installPhase fixupPhase";
    buildPhase = "";
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${bundler}/bin/bundle $out/bin/gitlab-runner \
          ${concatStrings (mapAttrsToList (name: value: "--set ${name} '\"${value}\"' ") gitlabEnv)} \
          --set GITLAB_CONFIG_PATH '"${cfg.statePath}/config"' \
          --set PATH '"${pkgs.nodejs}/bin:${pkgs.gzip}/bin:${config.services.postgresql.package}/bin:$PATH"' \
          --set RAKEOPT '"-f ${cfg.packages.gitlab}/share/gitlab/Rakefile"'
    '';
  };

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
        description = "Reference to the gitlab package";
      };

      packages.gitlab-shell = mkOption {
        type = types.package;
        default = pkgs.gitlab-shell;
        description = "Reference to the gitlab-shell package";
      };

      packages.gitlab-workhorse = mkOption {
        type = types.package;
        default = pkgs.gitlab-workhorse;
        description = "Reference to the gitlab-workhorse package";
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
        default = "";
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
        default = "UseNixOS!";
        description = ''
          Initial password of the root account if this is a new install.
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

    environment.systemPackages = [ pkgs.git gitlab-runner cfg.packages.gitlab-shell ];

    assertions = [
      { assertion = cfg.databasePassword != "";
        message = "databasePassword must be set";
      }
    ];

    # Redis is required for the sidekiq queue runner.
    services.redis.enable = mkDefault true;
    # We use postgres as the main data store.
    services.postgresql.enable = mkDefault true;
    # Use postfix to send out mails.
    services.postfix.enable = mkDefault true;

    users.extraUsers = [
      { name = cfg.user;
        group = cfg.group;
        home = "${cfg.statePath}/home";
        shell = "${pkgs.bash}/bin/bash";
        uid = config.ids.uids.gitlab;
      }
    ];

    users.extraGroups = [
      { name = cfg.group;
        gid = config.ids.gids.gitlab;
      }
    ];

    systemd.services.gitlab-sidekiq = {
      after = [ "network.target" "redis.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = gitlabEnv;
      path = with pkgs; [
        config.services.postgresql.package
        gitAndTools.git
        ruby
        openssh
        nodejs
      ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "300";
        WorkingDirectory = "${cfg.packages.gitlab}/share/gitlab";
        ExecStart="${bundler}/bin/bundle exec \"sidekiq -q post_receive -q mailers -q system_hook -q project_web_hook -q gitlab_shell -q common -q default -e production -P ${cfg.statePath}/tmp/sidekiq.pid\"";
      };
    };

    systemd.services.gitlab-workhorse = {
      after = [ "network.target" "gitlab.service" ];
      wantedBy = [ "multi-user.target" ];
      environment.HOME = gitlabEnv.HOME;
      environment.GITLAB_SHELL_CONFIG_PATH = gitlabEnv.GITLAB_SHELL_CONFIG_PATH;
      path = with pkgs; [
        gitAndTools.git
        openssh
      ];
      preStart = ''
        mkdir -p /run/gitlab
        chown ${cfg.user}:${cfg.group} /run/gitlab
      '';
      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "300";
        ExecStart =
          "${cfg.packages.gitlab-workhorse}/bin/gitlab-workhorse "
          + "-listenUmask 0 "
          + "-listenNetwork unix "
          + "-listenAddr /run/gitlab/gitlab-workhorse.socket "
          + "-authSocket ${gitlabSocket} "
          + "-documentRoot ${cfg.packages.gitlab}/share/gitlab/public";
      };
    };

    systemd.services.gitlab = {
      after = [ "network.target" "postgresql.service" "redis.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = gitlabEnv;
      path = with pkgs; [
        config.services.postgresql.package
        gitAndTools.git
        openssh
        nodejs
      ];
      preStart = ''
        mkdir -p ${cfg.backupPath}
        mkdir -p ${cfg.statePath}/builds
        mkdir -p ${cfg.statePath}/repositories
        mkdir -p ${gitlabConfig.production.shared.path}/artifacts
        mkdir -p ${gitlabConfig.production.shared.path}/lfs-objects
        mkdir -p ${cfg.statePath}/log
        mkdir -p ${cfg.statePath}/shell
        mkdir -p ${cfg.statePath}/tmp/pids
        mkdir -p ${cfg.statePath}/tmp/sockets

        rm -rf ${cfg.statePath}/config ${cfg.statePath}/shell/hooks
        mkdir -p ${cfg.statePath}/config ${cfg.statePath}/shell

        # TODO: What exactly is gitlab-shell doing with the secret?
        tr -dc _A-Z-a-z-0-9 < /dev/urandom | head -c 20 > ${cfg.statePath}/config/gitlab_shell_secret

        # The uploads directory is hardcoded somewhere deep in rails. It is
        # symlinked in the gitlab package to /run/gitlab/uploads to make it
        # configurable
        mkdir -p /run/gitlab
        mkdir -p ${cfg.statePath}/uploads
        ln -sf ${cfg.statePath}/uploads /run/gitlab/uploads
        chown -R ${cfg.user}:${cfg.group} /run/gitlab

        # Prepare home directory
        mkdir -p ${gitlabEnv.HOME}/.ssh
        touch ${gitlabEnv.HOME}/.ssh/authorized_keys
        chown -R ${cfg.user}:${cfg.group} ${gitlabEnv.HOME}/
        chmod -R u+rwX,go-rwx+X ${gitlabEnv.HOME}/

        cp -rf ${cfg.packages.gitlab}/share/gitlab/config.dist/* ${cfg.statePath}/config
        ln -sf ${cfg.statePath}/config /run/gitlab/config
        cp ${cfg.packages.gitlab}/share/gitlab/VERSION ${cfg.statePath}/VERSION

        # JSON is a subset of YAML
        ln -fs ${pkgs.writeText "gitlab.yml" (builtins.toJSON gitlabConfig)} ${cfg.statePath}/config/gitlab.yml
        ln -fs ${pkgs.writeText "database.yml" databaseYml} ${cfg.statePath}/config/database.yml
        ln -fs ${pkgs.writeText "unicorn.rb" unicornConfig} ${cfg.statePath}/config/unicorn.rb

        chown -R ${cfg.user}:${cfg.group} ${cfg.statePath}/
        chmod -R ug+rwX,o-rwx+X ${cfg.statePath}/

        # Install the shell required to push repositories
        ln -fs ${pkgs.writeText "config.yml" gitlabShellYml} "$GITLAB_SHELL_CONFIG_PATH"
        ln -fs ${cfg.packages.gitlab-shell}/hooks "$GITLAB_SHELL_HOOKS_PATH"
        ${cfg.packages.gitlab-shell}/bin/install

        if [ "${cfg.databaseHost}" = "127.0.0.1" ]; then
          if ! test -e "${cfg.statePath}/db-created"; then
            psql postgres -c "CREATE ROLE gitlab WITH LOGIN NOCREATEDB NOCREATEROLE NOCREATEUSER ENCRYPTED PASSWORD '${cfg.databasePassword}'"
            ${config.services.postgresql.package}/bin/createdb --owner gitlab gitlab || true
            touch "${cfg.statePath}/db-created"

            # The gitlab:setup task is horribly broken somehow, these two tasks will do the same for setting up the initial database
            ${gitlab-runner}/bin/gitlab-runner exec rake db:migrate RAILS_ENV=production
            ${gitlab-runner}/bin/gitlab-runner exec rake db:seed_fu RAILS_ENV=production \
              GITLAB_ROOT_PASSWORD="${cfg.initialRootPassword}" GITLAB_ROOT_EMAIL="${cfg.initialRootEmail}";
          fi
        fi

        # Always do the db migrations just to be sure the database is up-to-date
        ${gitlab-runner}/bin/gitlab-runner exec rake db:migrate RAILS_ENV=production

        # Change permissions in the last step because some of the
        # intermediary scripts like to create directories as root.
        chown -R ${cfg.user}:${cfg.group} ${cfg.statePath}
        chmod -R u+rwX,go-rwx+X ${cfg.statePath}
      '';

      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "300";
        WorkingDirectory = "${cfg.packages.gitlab}/share/gitlab";
        ExecStart="${bundler}/bin/bundle exec \"unicorn -c ${cfg.statePath}/config/unicorn.rb -E production\"";
      };

    };

  };
}
