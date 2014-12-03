{ config, lib, pkgs, ... }:

# TODO: support non-postgresql

with lib;

let
  cfg = config.services.gitlab;

  ruby = pkgs.ruby;
  rubyLibs = pkgs.rubyLibs;

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
    user: gitlab
    gitlab_url: "http://localhost:8080/"
    http_settings:
      self_signed_cert: false
    repos_path: "${cfg.stateDir}/repositories"
    log_file: "${cfg.stateDir}/log/gitlab-shell.log"
    redis:
      bin: ${pkgs.redis}/bin/redis-cli
      host: 127.0.0.1
      port: 6379
      database: 0
      namespace: resque:gitlab
  '';

  unicornConfig = builtins.readFile ./defaultUnicornConfig.rb;

  gitlab-runner = pkgs.stdenv.mkDerivation rec {
    name = "gitlab-runner";
    buildInputs = [ pkgs.gitlab pkgs.rubyLibs.bundler pkgs.makeWrapper ];
    phases = "installPhase fixupPhase";
    buildPhase = "";
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${rubyLibs.bundler}/bin/bundle $out/bin/gitlab-runner\
          --set RAKEOPT '"-f ${pkgs.gitlab}/share/gitlab/Rakefile"'\
          --set UNICORN_PATH "${cfg.stateDir}/"\
          --set GITLAB_PATH "${pkgs.gitlab}/share/gitlab/"\
          --set GITLAB_APPLICATION_LOG_PATH "${cfg.stateDir}/log/application.log"\
          --set GITLAB_SATELLITES_PATH "${cfg.stateDir}/satellites"\
          --set GITLAB_SHELL_PATH "${pkgs.gitlab-shell}"\
          --set GITLAB_REPOSITORIES_PATH "${cfg.stateDir}/repositories"\
          --set GITLAB_SHELL_HOOKS_PATH "${cfg.stateDir}/shell/hooks"\
          --set BUNDLE_GEMFILE "${pkgs.gitlab}/share/gitlab/Gemfile"\
          --set GITLAB_EMAIL_FROM "${cfg.emailFrom}"\
          --set GITLAB_SHELL_CONFIG_PATH "${cfg.stateDir}/shell/config.yml"\
          --set GITLAB_SHELL_SECRET_PATH "${cfg.stateDir}/config/gitlab_shell_secret"\
          --set GITLAB_HOST "${cfg.host}"\
          --set GITLAB_BACKUP_PATH"${cfg.backupPath}"\
          --set RAILS_ENV "production"
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

      satelliteDir = mkOption {
        type = types.str;
        default = "/var/gitlab/git-satellites";
        description = "Directory to store checked out git trees requires for operation.";
      };

      stateDir = mkOption {
        type = types.str;
        default = "/var/gitlab/state";
        description = "The state directory, logs are stored here.";
      };

      backupPath = mkOption {
        type = types.str;
        default = cfg.stateDir + "/backup";
        description = "Path for backups.";
      };

      databaseHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Database hostname";
      };

      databasePassword = mkOption {
        type = types.str;
        default = "";
        description = "Database user password";
      };

      databaseName = mkOption {
        type = types.str;
        default = "gitlab";
        description = "Database name";
      };

      databaseUsername = mkOption {
        type = types.str;
        default = "gitlab";
        description = "Database user";
      };

      emailFrom = mkOption {
        type = types.str;
        default = "example@example.org";
        description = "The source address for emails sent by gitlab.";
      };

      host = mkOption {
        type = types.str;
        default = config.networking.hostName;
        description = "The gitlab host name. Used e.g. for copy-paste URLs.";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ gitlab-runner pkgs.gitlab-shell ];

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
      { name = "gitlab";
        group = "gitlab";
        home = "${cfg.stateDir}/home";
        shell = "${pkgs.bash}/bin/bash";
        uid = config.ids.uids.gitlab;
      } ];

    users.extraGroups = [
      { name = "gitlab";
        gid = config.ids.gids.gitlab;
      } ];

    systemd.services.gitlab-sidekiq = {
      after = [ "network.target" "redis.service" ];
      wantedBy = [ "multi-user.target" ];
      environment.HOME = "${cfg.stateDir}/home";
      environment.UNICORN_PATH = "${cfg.stateDir}/";
      environment.GITLAB_PATH = "${pkgs.gitlab}/share/gitlab/";
      environment.GITLAB_APPLICATION_LOG_PATH = "${cfg.stateDir}/log/application.log";
      environment.GITLAB_SATELLITES_PATH = "${cfg.stateDir}/satellites";
      environment.GITLAB_SHELL_PATH = "${pkgs.gitlab-shell}";
      environment.GITLAB_REPOSITORIES_PATH = "${cfg.stateDir}/repositories";
      environment.GITLAB_SHELL_HOOKS_PATH = "${cfg.stateDir}/shell/hooks";
      environment.BUNDLE_GEMFILE = "${pkgs.gitlab}/share/gitlab/Gemfile";
      environment.GITLAB_EMAIL_FROM = "${cfg.emailFrom}";
      environment.GITLAB_SHELL_CONFIG_PATH = "${cfg.stateDir}/shell/config.yml";
      environment.GITLAB_SHELL_SECRET_PATH = "${cfg.stateDir}/config/gitlab_shell_secret";
      environment.GITLAB_HOST = "${cfg.host}";
      environment.GITLAB_DATABASE_HOST = "${cfg.databaseHost}";
      environment.GITLAB_DATABASE_PASSWORD = "${cfg.databasePassword}";
      environment.RAILS_ENV = "production";
      path = with pkgs; [
        config.services.postgresql.package
        gitAndTools.git
        ruby
        openssh
      ];
      serviceConfig = {
        Type = "simple";
        User = "gitlab";
        Group = "gitlab";
        TimeoutSec = "300";
        WorkingDirectory = "${pkgs.gitlab}/share/gitlab";
        ExecStart="${rubyLibs.bundler}/bin/bundle exec \"sidekiq -q post_receive -q mailer -q system_hook -q project_web_hook -q gitlab_shell -q common -q default -e production -P ${cfg.stateDir}/tmp/sidekiq.pid\"";
      };
    };

    systemd.services.gitlab = {
      after = [ "network.target" "postgresql.service" "redis.service" ];
      wantedBy = [ "multi-user.target" ];
      environment.HOME = "${cfg.stateDir}/home";
      environment.UNICORN_PATH = "${cfg.stateDir}/";
      environment.GITLAB_PATH = "${pkgs.gitlab}/share/gitlab/";
      environment.GITLAB_APPLICATION_LOG_PATH = "${cfg.stateDir}/log/application.log";
      environment.GITLAB_SATELLITES_PATH = "${cfg.stateDir}/satellites";
      environment.GITLAB_SHELL_PATH = "${pkgs.gitlab-shell}";
      environment.GITLAB_REPOSITORIES_PATH = "${cfg.stateDir}/repositories";
      environment.GITLAB_SHELL_HOOKS_PATH = "${cfg.stateDir}/shell/hooks";
      environment.BUNDLE_GEMFILE = "${pkgs.gitlab}/share/gitlab/Gemfile";
      environment.GITLAB_EMAIL_FROM = "${cfg.emailFrom}";
      environment.GITLAB_HOST = "${cfg.host}";
      environment.GITLAB_DATABASE_HOST = "${cfg.databaseHost}";
      environment.GITLAB_DATABASE_PASSWORD = "${cfg.databasePassword}";
      environment.RAILS_ENV = "production";
      path = with pkgs; [
        config.services.postgresql.package
        gitAndTools.git
        ruby
        openssh
      ];
      preStart = ''
        # TODO: use env vars
        mkdir -p ${cfg.stateDir}
        mkdir -p ${cfg.stateDir}/log
        mkdir -p ${cfg.stateDir}/satellites
        mkdir -p ${cfg.stateDir}/repositories
        mkdir -p ${cfg.stateDir}/shell/hooks
        mkdir -p ${cfg.stateDir}/tmp/pids
        mkdir -p ${cfg.stateDir}/tmp/sockets
        rm -rf ${cfg.stateDir}/config
        mkdir -p ${cfg.stateDir}/config
        # TODO: What exactly is gitlab-shell doing with the secret?
        head -c 20 /dev/urandom > ${cfg.stateDir}/config/gitlab_shell_secret
        mkdir -p ${cfg.stateDir}/home/.ssh
        touch ${cfg.stateDir}/home/.ssh/authorized_keys

        cp -rf ${pkgs.gitlab}/share/gitlab/config ${cfg.stateDir}/
        cp ${pkgs.gitlab}/share/gitlab/VERSION ${cfg.stateDir}/VERSION

        ln -fs ${pkgs.writeText "database.yml" databaseYml} ${cfg.stateDir}/config/database.yml
        ln -fs ${pkgs.writeText "unicorn.rb" unicornConfig} ${cfg.stateDir}/config/unicorn.rb

        chown -R gitlab:gitlab ${cfg.stateDir}/
        chmod -R 755 ${cfg.stateDir}/

        if [ "${cfg.databaseHost}" = "127.0.0.1" ]; then
          if ! test -e "${cfg.stateDir}/db-created"; then
            psql postgres -c "CREATE ROLE gitlab WITH LOGIN NOCREATEDB NOCREATEROLE NOCREATEUSER ENCRYPTED PASSWORD '${cfg.databasePassword}'"
            ${config.services.postgresql.package}/bin/createdb --owner gitlab gitlab || true
            touch "${cfg.stateDir}/db-created"

            # force=yes disables the manual-interaction yes/no prompt
            # which breaks without an stdin.
            force=yes ${rubyLibs.bundler}/bin/bundle exec rake -f ${pkgs.gitlab}/share/gitlab/Rakefile gitlab:setup RAILS_ENV=production
          fi
        fi

      # Install the shell required to push repositories
      ln -fs ${pkgs.writeText "config.yml" gitlabShellYml} ${cfg.stateDir}/shell/config.yml
      export GITLAB_SHELL_CONFIG_PATH=""${cfg.stateDir}/shell/config.yml
      ${pkgs.gitlab-shell}/bin/install

      # Change permissions in the last step because some of the
      # intermediary scripts like to create directories as root.
      chown -R gitlab:gitlab ${cfg.stateDir}/
      chmod -R 755 ${cfg.stateDir}/
      '';

      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        Type = "simple";
        User = "gitlab";
        Group = "gitlab";
        TimeoutSec = "300";
        WorkingDirectory = "${pkgs.gitlab}/share/gitlab";
        ExecStart="${rubyLibs.bundler}/bin/bundle exec \"unicorn -c ${cfg.stateDir}/config/unicorn.rb -E production\"";
      };

    };

  };

}
