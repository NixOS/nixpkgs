{ config, lib, options, pkgs, utils, ... }:

with lib;

let
  cfg = config.services.gitlab;
  opt = options.services.gitlab;

  ruby = cfg.packages.gitlab.ruby;

  postgresqlPackage = if config.services.postgresql.enable then
                        config.services.postgresql.package
                      else
                        pkgs.postgresql_12;

  # Git 2.36.1 seemingly contains a commit-graph related bug which is
  # easily triggered through GitLab, so we downgrade it to 2.35.x
  # until this issue is solved. See
  # https://gitlab.com/gitlab-org/gitlab/-/issues/360783#note_992870101.
  gitPackage =
    let
      version = "2.35.4";
    in
      pkgs.git.overrideAttrs (oldAttrs: rec {
        inherit version;
        src = pkgs.fetchurl {
          url = "https://www.kernel.org/pub/software/scm/git/git-${version}.tar.xz";
          sha256 = "sha256-mv13OdNkXggeKQkJ+47QcJ6lYmcw6Qjri1ZJ2ETCTOk=";
        };
      });

  gitlabSocket = "${cfg.statePath}/tmp/sockets/gitlab.socket";
  gitalySocket = "${cfg.statePath}/tmp/sockets/gitaly.socket";
  pathUrlQuote = url: replaceStrings ["/"] ["%2F"] url;

  databaseConfig = let
    val = {
      adapter = "postgresql";
      database = cfg.databaseName;
      host = cfg.databaseHost;
      username = cfg.databaseUsername;
      encoding = "utf8";
      pool = cfg.databasePool;
    } // cfg.extraDatabaseConfig;
  in if lib.versionAtLeast (lib.getVersion cfg.packages.gitlab) "15.0" then {
    production.main = val;
  } else {
    production = val;
  };

  # We only want to create a database if we're actually going to connect to it.
  databaseActuallyCreateLocally = cfg.databaseCreateLocally && cfg.databaseHost == "";

  gitalyToml = pkgs.writeText "gitaly.toml" ''
    socket_path = "${lib.escape ["\""] gitalySocket}"
    bin_dir = "${cfg.packages.gitaly}/bin"
    prometheus_listen_addr = "localhost:9236"

    [git]
    bin_path = "${gitPackage}/bin/git"

    [gitaly-ruby]
    dir = "${cfg.packages.gitaly.ruby}"

    [gitlab-shell]
    dir = "${cfg.packages.gitlab-shell}"

    [hooks]
    custom_hooks_dir = "${cfg.statePath}/custom_hooks"

    [gitlab]
    secret_file = "${cfg.statePath}/gitlab_shell_secret"
    url = "http+unix://${pathUrlQuote gitlabSocket}"

    [gitlab.http-settings]
    self_signed_cert = false

    ${concatStringsSep "\n" (attrValues (mapAttrs (k: v: ''
    [[storage]]
    name = "${lib.escape ["\""] k}"
    path = "${lib.escape ["\""] v.path}"
    '') gitlabConfig.production.repositories.storages))}
  '';

  gitlabShellConfig = flip recursiveUpdate cfg.extraShellConfig {
    user = cfg.user;
    gitlab_url = "http+unix://${pathUrlQuote gitlabSocket}";
    http_settings.self_signed_cert = false;
    repos_path = "${cfg.statePath}/repositories";
    secret_file = "${cfg.statePath}/gitlab_shell_secret";
    log_file = "${cfg.statePath}/log/gitlab-shell.log";
    redis = {
      bin = "${pkgs.redis}/bin/redis-cli";
      host = "127.0.0.1";
      port = config.services.redis.servers.gitlab.port;
      database = 0;
      namespace = "resque:gitlab";
    };
  };

  redisConfig.production.url = cfg.redisUrl;

  pagesArgs = [
    "-pages-domain" gitlabConfig.production.pages.host
    "-pages-root" "${gitlabConfig.production.shared.path}/pages"
  ] ++ cfg.pagesExtraArgs;

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
      backup = {
        gitaly_backup_path = "${cfg.packages.gitaly}/bin/gitaly-backup";
        path = cfg.backup.path;
        keep_time = cfg.backup.keepTime;
      } // (optionalAttrs (cfg.backup.uploadOptions != {}) {
        upload = cfg.backup.uploadOptions;
      });
      gitlab_shell = {
        path = "${cfg.packages.gitlab-shell}";
        hooks_path = "${cfg.statePath}/shell/hooks";
        secret_file = "${cfg.statePath}/gitlab_shell_secret";
        upload_pack = true;
        receive_pack = true;
      };
      workhorse.secret_file = "${cfg.statePath}/.gitlab_workhorse_secret";
      gitlab_kas.secret_file = "${cfg.statePath}/.gitlab_kas_secret";
      git.bin_path = "${gitPackage}/bin/git";
      monitoring = {
        ip_whitelist = [ "127.0.0.0/8" "::1/128" ];
        sidekiq_exporter = {
          enable = true;
          address = "localhost";
          port = 3807;
        };
      };
      registry = lib.optionalAttrs cfg.registry.enable {
        enabled = true;
        host = cfg.registry.externalAddress;
        port = cfg.registry.externalPort;
        key = cfg.registry.keyFile;
        api_url = "http://${config.services.dockerRegistry.listenAddress}:${toString config.services.dockerRegistry.port}/";
        issuer = cfg.registry.issuer;
      };
      extra = {};
      uploads.storage_path = cfg.statePath;
    };
  };

  gitlabEnv = cfg.packages.gitlab.gitlabEnv // {
    HOME = "${cfg.statePath}/home";
    PUMA_PATH = "${cfg.statePath}/";
    GITLAB_PATH = "${cfg.packages.gitlab}/share/gitlab/";
    SCHEMA = "${cfg.statePath}/db/structure.sql";
    GITLAB_UPLOADS_PATH = "${cfg.statePath}/uploads";
    GITLAB_LOG_PATH = "${cfg.statePath}/log";
    GITLAB_REDIS_CONFIG_FILE = pkgs.writeText "redis.yml" (builtins.toJSON redisConfig);
    prometheus_multiproc_dir = "/run/gitlab";
    RAILS_ENV = "production";
    MALLOC_ARENA_MAX = "2";
  } // cfg.extraEnv;

  gitlab-rake = pkgs.stdenv.mkDerivation {
    name = "gitlab-rake";
    buildInputs = [ pkgs.makeWrapper ];
    dontBuild = true;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${cfg.packages.gitlab.rubyEnv}/bin/rake $out/bin/gitlab-rake \
          ${concatStrings (mapAttrsToList (name: value: "--set ${name} '${value}' ") gitlabEnv)} \
          --set PATH '${lib.makeBinPath [ pkgs.nodejs pkgs.gzip pkgs.git pkgs.gnutar postgresqlPackage pkgs.coreutils pkgs.procps ]}:$PATH' \
          --set RAKEOPT '-f ${cfg.packages.gitlab}/share/gitlab/Rakefile' \
          --chdir '${cfg.packages.gitlab}/share/gitlab'
     '';
  };

  gitlab-rails = pkgs.stdenv.mkDerivation {
    name = "gitlab-rails";
    buildInputs = [ pkgs.makeWrapper ];
    dontBuild = true;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${cfg.packages.gitlab.rubyEnv}/bin/rails $out/bin/gitlab-rails \
          ${concatStrings (mapAttrsToList (name: value: "--set ${name} '${value}' ") gitlabEnv)} \
          --set PATH '${lib.makeBinPath [ pkgs.nodejs pkgs.gzip pkgs.git pkgs.gnutar postgresqlPackage pkgs.coreutils pkgs.procps ]}:$PATH' \
          --chdir '${cfg.packages.gitlab}/share/gitlab'
     '';
  };

  extraGitlabRb = pkgs.writeText "extra-gitlab.rb" cfg.extraGitlabRb;

  smtpSettings = pkgs.writeText "gitlab-smtp-settings.rb" ''
    if Rails.env.production?
      Rails.application.config.action_mailer.delivery_method = :smtp

      ActionMailer::Base.delivery_method = :smtp
      ActionMailer::Base.smtp_settings = {
        address: "${cfg.smtp.address}",
        port: ${toString cfg.smtp.port},
        ${optionalString (cfg.smtp.username != null) ''user_name: "${cfg.smtp.username}",''}
        ${optionalString (cfg.smtp.passwordFile != null) ''password: "@smtpPassword@",''}
        domain: "${cfg.smtp.domain}",
        ${optionalString (cfg.smtp.authentication != null) "authentication: :${cfg.smtp.authentication},"}
        enable_starttls_auto: ${boolToString cfg.smtp.enableStartTLSAuto},
        tls: ${boolToString cfg.smtp.tls},
        ca_file: "/etc/ssl/certs/ca-certificates.crt",
        openssl_verify_mode: '${cfg.smtp.opensslVerifyMode}'
      }
    end
  '';

in {

  imports = [
    (mkRenamedOptionModule [ "services" "gitlab" "stateDir" ] [ "services" "gitlab" "statePath" ])
    (mkRenamedOptionModule [ "services" "gitlab" "backupPath" ] [ "services" "gitlab" "backup" "path" ])
    (mkRemovedOptionModule [ "services" "gitlab" "satelliteDir" ] "")
  ];

  options = {
    services.gitlab = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable the gitlab service.
        '';
      };

      packages.gitlab = mkOption {
        type = types.package;
        default = pkgs.gitlab;
        defaultText = literalExpression "pkgs.gitlab";
        description = lib.mdDoc "Reference to the gitlab package";
        example = literalExpression "pkgs.gitlab-ee";
      };

      packages.gitlab-shell = mkOption {
        type = types.package;
        default = pkgs.gitlab-shell;
        defaultText = literalExpression "pkgs.gitlab-shell";
        description = lib.mdDoc "Reference to the gitlab-shell package";
      };

      packages.gitlab-workhorse = mkOption {
        type = types.package;
        default = pkgs.gitlab-workhorse;
        defaultText = literalExpression "pkgs.gitlab-workhorse";
        description = lib.mdDoc "Reference to the gitlab-workhorse package";
      };

      packages.gitaly = mkOption {
        type = types.package;
        default = pkgs.gitaly;
        defaultText = literalExpression "pkgs.gitaly";
        description = lib.mdDoc "Reference to the gitaly package";
      };

      packages.pages = mkOption {
        type = types.package;
        default = pkgs.gitlab-pages;
        defaultText = literalExpression "pkgs.gitlab-pages";
        description = lib.mdDoc "Reference to the gitlab-pages package";
      };

      statePath = mkOption {
        type = types.str;
        default = "/var/gitlab/state";
        description = lib.mdDoc ''
          GitLab state directory. Configuration, repositories and
          logs, among other things, are stored here.

          The directory will be created automatically if it doesn't
          exist already. Its parent directories must be owned by
          either `root` or the user set in
          {option}`services.gitlab.user`.
        '';
      };

      extraEnv = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = lib.mdDoc ''
          Additional environment variables for the GitLab environment.
        '';
      };

      backup.startAt = mkOption {
        type = with types; either str (listOf str);
        default = [];
        example = "03:00";
        description = lib.mdDoc ''
          The time(s) to run automatic backup of GitLab
          state. Specified in systemd's time format; see
          {manpage}`systemd.time(7)`.
        '';
      };

      backup.path = mkOption {
        type = types.str;
        default = cfg.statePath + "/backup";
        defaultText = literalExpression ''config.${opt.statePath} + "/backup"'';
        description = lib.mdDoc "GitLab path for backups.";
      };

      backup.keepTime = mkOption {
        type = types.int;
        default = 0;
        example = 48;
        apply = x: x * 60 * 60;
        description = lib.mdDoc ''
          How long to keep the backups around, in
          hours. `0` means “keep forever”.
        '';
      };

      backup.skip = mkOption {
        type = with types;
          let value = enum [
                "db"
                "uploads"
                "builds"
                "artifacts"
                "lfs"
                "registry"
                "pages"
                "repositories"
                "tar"
              ];
          in
            either value (listOf value);
        default = [];
        example = [ "artifacts" "lfs" ];
        apply = x: if isString x then x else concatStringsSep "," x;
        description = lib.mdDoc ''
          Directories to exclude from the backup. The example excludes
          CI artifacts and LFS objects from the backups. The
          `tar` option skips the creation of a tar
          file.

          Refer to <https://docs.gitlab.com/ee/raketasks/backup_restore.html#excluding-specific-directories-from-the-backup>
          for more information.
        '';
      };

      backup.uploadOptions = mkOption {
        type = types.attrs;
        default = {};
        example = literalExpression ''
          {
            # Fog storage connection settings, see http://fog.io/storage/
            connection = {
              provider = "AWS";
              region = "eu-north-1";
              aws_access_key_id = "AKIAXXXXXXXXXXXXXXXX";
              aws_secret_access_key = { _secret = config.deployment.keys.aws_access_key.path; };
            };

            # The remote 'directory' to store your backups in.
            # For S3, this would be the bucket name.
            remote_directory = "my-gitlab-backups";

            # Use multipart uploads when file size reaches 100MB, see
            # http://docs.aws.amazon.com/AmazonS3/latest/dev/uploadobjusingmpu.html
            multipart_chunk_size = 104857600;

            # Turns on AWS Server-Side Encryption with Amazon S3-Managed Keys for backups, this is optional
            encryption = "AES256";

            # Specifies Amazon S3 storage class to use for backups, this is optional
            storage_class = "STANDARD";
          };
        '';
        description = lib.mdDoc ''
          GitLab automatic upload specification. Tells GitLab to
          upload the backup to a remote location when done.

          Attributes specified here are added under
          `production -> backup -> upload` in
          {file}`config/gitlab.yml`.
        '';
      };

      databaseHost = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          GitLab database hostname. An empty string means
          “use local unix socket connection”.
        '';
      };

      databasePasswordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = lib.mdDoc ''
          File containing the GitLab database user password.

          This should be a string, not a nix path, since nix paths are
          copied into the world-readable nix store.
        '';
      };

      databaseCreateLocally = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether a database should be automatically created on the
          local host. Set this to `false` if you plan
          on provisioning a local database yourself. This has no effect
          if {option}`services.gitlab.databaseHost` is customized.
        '';
      };

      databaseName = mkOption {
        type = types.str;
        default = "gitlab";
        description = lib.mdDoc "GitLab database name.";
      };

      databaseUsername = mkOption {
        type = types.str;
        default = "gitlab";
        description = lib.mdDoc "GitLab database user.";
      };

      databasePool = mkOption {
        type = types.int;
        default = 5;
        description = lib.mdDoc "Database connection pool size.";
      };

      extraDatabaseConfig = mkOption {
        type = types.attrs;
        default = {};
        description = lib.mdDoc "Extra configuration in config/database.yml.";
      };

      redisUrl = mkOption {
        type = types.str;
        default = "redis://localhost:${toString config.services.redis.servers.gitlab.port}/";
        defaultText = literalExpression ''redis://localhost:''${toString config.services.redis.servers.gitlab.port}/'';
        description = lib.mdDoc "Redis URL for all GitLab services except gitlab-shell";
      };

      extraGitlabRb = mkOption {
        type = types.str;
        default = "";
        example = ''
          if Rails.env.production?
            Rails.application.config.action_mailer.delivery_method = :sendmail
            ActionMailer::Base.delivery_method = :sendmail
            ActionMailer::Base.sendmail_settings = {
              location: "/run/wrappers/bin/sendmail",
              arguments: "-i -t"
            }
          end
        '';
        description = lib.mdDoc ''
          Extra configuration to be placed in config/extra-gitlab.rb. This can
          be used to add configuration not otherwise exposed through this module's
          options.
        '';
      };

      host = mkOption {
        type = types.str;
        default = config.networking.hostName;
        defaultText = literalExpression "config.networking.hostName";
        description = lib.mdDoc "GitLab host name. Used e.g. for copy-paste URLs.";
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = lib.mdDoc ''
          GitLab server port for copy-paste URLs, e.g. 80 or 443 if you're
          service over https.
        '';
      };

      https = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether gitlab prints URLs with https as scheme.";
      };

      user = mkOption {
        type = types.str;
        default = "gitlab";
        description = lib.mdDoc "User to run gitlab and all related services.";
      };

      group = mkOption {
        type = types.str;
        default = "gitlab";
        description = lib.mdDoc "Group to run gitlab and all related services.";
      };

      initialRootEmail = mkOption {
        type = types.str;
        default = "admin@local.host";
        description = lib.mdDoc ''
          Initial email address of the root account if this is a new install.
        '';
      };

      initialRootPasswordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = lib.mdDoc ''
          File containing the initial password of the root account if
          this is a new install.

          This should be a string, not a nix path, since nix paths are
          copied into the world-readable nix store.
        '';
      };

      registry = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Enable GitLab container registry.";
        };
        host = mkOption {
          type = types.str;
          default = config.services.gitlab.host;
          defaultText = literalExpression "config.services.gitlab.host";
          description = lib.mdDoc "GitLab container registry host name.";
        };
        port = mkOption {
          type = types.int;
          default = 4567;
          description = lib.mdDoc "GitLab container registry port.";
        };
        certFile = mkOption {
          type = types.path;
          description = lib.mdDoc "Path to GitLab container registry certificate.";
        };
        keyFile = mkOption {
          type = types.path;
          description = lib.mdDoc "Path to GitLab container registry certificate-key.";
        };
        defaultForProjects = mkOption {
          type = types.bool;
          default = cfg.registry.enable;
          defaultText = literalExpression "config.${opt.registry.enable}";
          description = lib.mdDoc "If GitLab container registry should be enabled by default for projects.";
        };
        issuer = mkOption {
          type = types.str;
          default = "gitlab-issuer";
          description = lib.mdDoc "GitLab container registry issuer.";
        };
        serviceName = mkOption {
          type = types.str;
          default = "container_registry";
          description = lib.mdDoc "GitLab container registry service name.";
        };
        externalAddress = mkOption {
          type = types.str;
          default = "";
          description = lib.mdDoc "External address used to access registry from the internet";
        };
        externalPort = mkOption {
          type = types.int;
          description = lib.mdDoc "External port used to access registry from the internet";
        };
      };

      smtp = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Enable gitlab mail delivery over SMTP.";
        };

        address = mkOption {
          type = types.str;
          default = "localhost";
          description = lib.mdDoc "Address of the SMTP server for GitLab.";
        };

        port = mkOption {
          type = types.int;
          default = 25;
          description = lib.mdDoc "Port of the SMTP server for GitLab.";
        };

        username = mkOption {
          type = with types; nullOr str;
          default = null;
          description = lib.mdDoc "Username of the SMTP server for GitLab.";
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = lib.mdDoc ''
            File containing the password of the SMTP server for GitLab.

            This should be a string, not a nix path, since nix paths
            are copied into the world-readable nix store.
          '';
        };

        domain = mkOption {
          type = types.str;
          default = "localhost";
          description = lib.mdDoc "HELO domain to use for outgoing mail.";
        };

        authentication = mkOption {
          type = with types; nullOr str;
          default = null;
          description = lib.mdDoc "Authentication type to use, see http://api.rubyonrails.org/classes/ActionMailer/Base.html";
        };

        enableStartTLSAuto = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc "Whether to try to use StartTLS.";
        };

        tls = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Whether to use TLS wrapper-mode.";
        };

        opensslVerifyMode = mkOption {
          type = types.str;
          default = "peer";
          description = lib.mdDoc "How OpenSSL checks the certificate, see http://api.rubyonrails.org/classes/ActionMailer/Base.html";
        };
      };

      pagesExtraArgs = mkOption {
        type = types.listOf types.str;
        default = [ "-listen-proxy" "127.0.0.1:8090" ];
        description = lib.mdDoc "Arguments to pass to the gitlab-pages daemon";
      };

      secrets.secretFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = lib.mdDoc ''
          A file containing the secret used to encrypt variables in
          the DB. If you change or lose this key you will be unable to
          access variables stored in database.

          Make sure the secret is at least 32 characters and all random,
          no regular words or you'll be exposed to dictionary attacks.

          This should be a string, not a nix path, since nix paths are
          copied into the world-readable nix store.
        '';
      };

      secrets.dbFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = lib.mdDoc ''
          A file containing the secret used to encrypt variables in
          the DB. If you change or lose this key you will be unable to
          access variables stored in database.

          Make sure the secret is at least 32 characters and all random,
          no regular words or you'll be exposed to dictionary attacks.

          This should be a string, not a nix path, since nix paths are
          copied into the world-readable nix store.
        '';
      };

      secrets.otpFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = lib.mdDoc ''
          A file containing the secret used to encrypt secrets for OTP
          tokens. If you change or lose this key, users which have 2FA
          enabled for login won't be able to login anymore.

          Make sure the secret is at least 32 characters and all random,
          no regular words or you'll be exposed to dictionary attacks.

          This should be a string, not a nix path, since nix paths are
          copied into the world-readable nix store.
        '';
      };

      secrets.jwsFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = lib.mdDoc ''
          A file containing the secret used to encrypt session
          keys. If you change or lose this key, users will be
          disconnected.

          Make sure the secret is an RSA private key in PEM format. You can
          generate one with

          openssl genrsa 2048

          This should be a string, not a nix path, since nix paths are
          copied into the world-readable nix store.
        '';
      };

      extraShellConfig = mkOption {
        type = types.attrs;
        default = {};
        description = lib.mdDoc "Extra configuration to merge into shell-config.yml";
      };

      puma.workers = mkOption {
        type = types.int;
        default = 2;
        apply = x: builtins.toString x;
        description = lib.mdDoc ''
          The number of worker processes Puma should spawn. This
          controls the amount of parallel Ruby code can be
          executed. GitLab recommends `Number of CPU cores - 1`, but at least two.

          ::: {.note}
          Each worker consumes quite a bit of memory, so
          be careful when increasing this.
          :::
        '';
      };

      puma.threadsMin = mkOption {
        type = types.int;
        default = 0;
        apply = x: builtins.toString x;
        description = lib.mdDoc ''
          The minimum number of threads Puma should use per
          worker.

          ::: {.note}
          Each thread consumes memory and contributes to Global VM
          Lock contention, so be careful when increasing this.
          :::
        '';
      };

      puma.threadsMax = mkOption {
        type = types.int;
        default = 4;
        apply = x: builtins.toString x;
        description = lib.mdDoc ''
          The maximum number of threads Puma should use per
          worker. This limits how many threads Puma will automatically
          spawn in response to requests. In contrast to workers,
          threads will never be able to run Ruby code in parallel, but
          give higher IO parallelism.

          ::: {.note}
          Each thread consumes memory and contributes to Global VM
          Lock contention, so be careful when increasing this.
          :::
        '';
      };

      sidekiq.memoryKiller.enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether the Sidekiq MemoryKiller should be turned
          on. MemoryKiller kills Sidekiq when its memory consumption
          exceeds a certain limit.

          See <https://docs.gitlab.com/ee/administration/operations/sidekiq_memory_killer.html>
          for details.
        '';
      };

      sidekiq.memoryKiller.maxMemory = mkOption {
        type = types.int;
        default = 2000;
        apply = x: builtins.toString (x * 1024);
        description = lib.mdDoc ''
          The maximum amount of memory, in MiB, a Sidekiq worker is
          allowed to consume before being killed.
        '';
      };

      sidekiq.memoryKiller.graceTime = mkOption {
        type = types.int;
        default = 900;
        apply = x: builtins.toString x;
        description = lib.mdDoc ''
          The time MemoryKiller waits after noticing excessive memory
          consumption before killing Sidekiq.
        '';
      };

      sidekiq.memoryKiller.shutdownWait = mkOption {
        type = types.int;
        default = 30;
        apply = x: builtins.toString x;
        description = lib.mdDoc ''
          The time allowed for all jobs to finish before Sidekiq is
          killed forcefully.
        '';
      };

      logrotate = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Enable rotation of log files.
          '';
        };

        frequency = mkOption {
          type = types.str;
          default = "daily";
          description = lib.mdDoc "How often to rotate the logs.";
        };

        keep = mkOption {
          type = types.int;
          default = 30;
          description = lib.mdDoc "How many rotations to keep.";
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = lib.mdDoc ''
            Extra logrotate config options for this path. Refer to
            <https://linux.die.net/man/8/logrotate> for details.
          '';
        };
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        example = literalExpression ''
          {
            gitlab = {
              default_projects_features = {
                builds = false;
              };
            };
            omniauth = {
              enabled = true;
              auto_sign_in_with_provider = "openid_connect";
              allow_single_sign_on = ["openid_connect"];
              block_auto_created_users = false;
              providers = [
                {
                  name = "openid_connect";
                  label = "OpenID Connect";
                  args = {
                    name = "openid_connect";
                    scope = ["openid" "profile"];
                    response_type = "code";
                    issuer = "https://keycloak.example.com/auth/realms/My%20Realm";
                    discovery = true;
                    client_auth_method = "query";
                    uid_field = "preferred_username";
                    client_options = {
                      identifier = "gitlab";
                      secret = { _secret = "/var/keys/gitlab_oidc_secret"; };
                      redirect_uri = "https://git.example.com/users/auth/openid_connect/callback";
                    };
                  };
                }
              ];
            };
          };
        '';
        description = lib.mdDoc ''
          Extra options to be added under
          `production` in
          {file}`config/gitlab.yml`, as a nix attribute
          set.

          Options containing secret data should be set to an attribute
          set containing the attribute `_secret` - a
          string pointing to a file containing the value the option
          should be set to. See the example to get a better picture of
          this: in the resulting
          {file}`config/gitlab.yml` file, the
          `production.omniauth.providers[0].args.client_options.secret`
          key will be set to the contents of the
          {file}`/var/keys/gitlab_oidc_secret` file.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = databaseActuallyCreateLocally -> (cfg.user == cfg.databaseUsername);
        message = ''For local automatic database provisioning (services.gitlab.databaseCreateLocally == true) with peer authentication (services.gitlab.databaseHost == "") to work services.gitlab.user and services.gitlab.databaseUsername must be identical.'';
      }
      {
        assertion = (cfg.databaseHost != "") -> (cfg.databasePasswordFile != null);
        message = "When services.gitlab.databaseHost is customized, services.gitlab.databasePasswordFile must be set!";
      }
      {
        assertion = cfg.initialRootPasswordFile != null;
        message = "services.gitlab.initialRootPasswordFile must be set!";
      }
      {
        assertion = cfg.secrets.secretFile != null;
        message = "services.gitlab.secrets.secretFile must be set!";
      }
      {
        assertion = cfg.secrets.dbFile != null;
        message = "services.gitlab.secrets.dbFile must be set!";
      }
      {
        assertion = cfg.secrets.otpFile != null;
        message = "services.gitlab.secrets.otpFile must be set!";
      }
      {
        assertion = cfg.secrets.jwsFile != null;
        message = "services.gitlab.secrets.jwsFile must be set!";
      }
      {
        assertion = versionAtLeast postgresqlPackage.version "12.0.0";
        message = "PostgreSQL >=12 is required to run GitLab 14. Follow the instructions in the manual section for upgrading PostgreSQL here: https://nixos.org/manual/nixos/stable/index.html#module-services-postgres-upgrading";
      }
    ];

    environment.systemPackages = [ pkgs.git gitlab-rake gitlab-rails cfg.packages.gitlab-shell ];

    systemd.targets.gitlab = {
      description = "Common target for all GitLab services.";
      wantedBy = [ "multi-user.target" ];
    };

    # Redis is required for the sidekiq queue runner.
    services.redis.servers.gitlab = {
      enable = mkDefault true;
      port = mkDefault 31636;
      bind = mkDefault "127.0.0.1";
    };

    # We use postgres as the main data store.
    services.postgresql = optionalAttrs databaseActuallyCreateLocally {
      enable = true;
      ensureUsers = singleton { name = cfg.databaseUsername; };
    };

    # Enable rotation of log files
    services.logrotate = {
      enable = cfg.logrotate.enable;
      settings = {
        gitlab = {
          files = "${cfg.statePath}/log/*.log";
          su = "${cfg.user} ${cfg.group}";
          frequency = cfg.logrotate.frequency;
          rotate = cfg.logrotate.keep;
          copytruncate = true;
          compress = true;
          extraConfig = cfg.logrotate.extraConfig;
        };
      };
    };

    # The postgresql module doesn't currently support concepts like
    # objects owners and extensions; for now we tack on what's needed
    # here.
    systemd.services.gitlab-postgresql = let pgsql = config.services.postgresql; in mkIf databaseActuallyCreateLocally {
      after = [ "postgresql.service" ];
      bindsTo = [ "postgresql.service" ];
      wantedBy = [ "gitlab.target" ];
      partOf = [ "gitlab.target" ];
      path = [
        pgsql.package
        pkgs.util-linux
      ];
      script = ''
        set -eu

        PSQL() {
            psql --port=${toString pgsql.port} "$@"
        }

        PSQL -tAc "SELECT 1 FROM pg_database WHERE datname = '${cfg.databaseName}'" | grep -q 1 || PSQL -tAc 'CREATE DATABASE "${cfg.databaseName}" OWNER "${cfg.databaseUsername}"'
        current_owner=$(PSQL -tAc "SELECT pg_catalog.pg_get_userbyid(datdba) FROM pg_catalog.pg_database WHERE datname = '${cfg.databaseName}'")
        if [[ "$current_owner" != "${cfg.databaseUsername}" ]]; then
            PSQL -tAc 'ALTER DATABASE "${cfg.databaseName}" OWNER TO "${cfg.databaseUsername}"'
            if [[ -e "${config.services.postgresql.dataDir}/.reassigning_${cfg.databaseName}" ]]; then
                echo "Reassigning ownership of database ${cfg.databaseName} to user ${cfg.databaseUsername} failed on last boot. Failing..."
                exit 1
            fi
            touch "${config.services.postgresql.dataDir}/.reassigning_${cfg.databaseName}"
            PSQL "${cfg.databaseName}" -tAc "REASSIGN OWNED BY \"$current_owner\" TO \"${cfg.databaseUsername}\""
            rm "${config.services.postgresql.dataDir}/.reassigning_${cfg.databaseName}"
        fi
        PSQL '${cfg.databaseName}' -tAc "CREATE EXTENSION IF NOT EXISTS pg_trgm"
        PSQL '${cfg.databaseName}' -tAc "CREATE EXTENSION IF NOT EXISTS btree_gist;"
      '';

      serviceConfig = {
        User = pgsql.superUser;
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

    systemd.services.gitlab-registry-cert = optionalAttrs cfg.registry.enable {
      path = with pkgs; [ openssl ];

      script = ''
        mkdir -p $(dirname ${cfg.registry.keyFile})
        mkdir -p $(dirname ${cfg.registry.certFile})
        openssl req -nodes -newkey rsa:4096 -keyout ${cfg.registry.keyFile} -out /tmp/registry-auth.csr -subj "/CN=${cfg.registry.issuer}"
        openssl x509 -in /tmp/registry-auth.csr -out ${cfg.registry.certFile} -req -signkey ${cfg.registry.keyFile} -days 3650
        chown ${cfg.user}:${cfg.group} $(dirname ${cfg.registry.keyFile})
        chown ${cfg.user}:${cfg.group} $(dirname ${cfg.registry.certFile})
        chown ${cfg.user}:${cfg.group} ${cfg.registry.keyFile}
        chown ${cfg.user}:${cfg.group} ${cfg.registry.certFile}
      '';

      unitConfig = {
        ConditionPathExists = "!${cfg.registry.certFile}";
      };
    };

    # Ensure Docker Registry launches after the certificate generation job
    systemd.services.docker-registry = optionalAttrs cfg.registry.enable {
      wants = [ "gitlab-registry-cert.service" ];
    };

    # Enable Docker Registry, if GitLab-Container Registry is enabled
    services.dockerRegistry = optionalAttrs cfg.registry.enable {
      enable = true;
      enableDelete = true; # This must be true, otherwise GitLab won't manage it correctly
      extraConfig = {
        auth.token = {
          realm = "http${if cfg.https == true then "s" else ""}://${cfg.host}/jwt/auth";
          service = cfg.registry.serviceName;
          issuer = cfg.registry.issuer;
          rootcertbundle = cfg.registry.certFile;
        };
      };
    };

    # Use postfix to send out mails.
    services.postfix.enable = mkDefault (cfg.smtp.enable && cfg.smtp.address == "localhost");

    users.users.${cfg.user} =
      { group = cfg.group;
        home = "${cfg.statePath}/home";
        shell = "${pkgs.bash}/bin/bash";
        uid = config.ids.uids.gitlab;
      };

    users.groups.${cfg.group}.gid = config.ids.gids.gitlab;

    systemd.tmpfiles.rules = [
      "d /run/gitlab 0755 ${cfg.user} ${cfg.group} -"
      "d ${gitlabEnv.HOME} 0750 ${cfg.user} ${cfg.group} -"
      "z ${gitlabEnv.HOME}/.ssh/authorized_keys 0600 ${cfg.user} ${cfg.group} -"
      "d ${cfg.backup.path} 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath} 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/builds 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/config 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/db 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/log 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/repositories 2770 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/shell 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/tmp 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/tmp/pids 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/tmp/sockets 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/uploads 0700 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/custom_hooks 0700 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/custom_hooks/pre-receive.d 0700 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/custom_hooks/post-receive.d 0700 ${cfg.user} ${cfg.group} -"
      "d ${cfg.statePath}/custom_hooks/update.d 0700 ${cfg.user} ${cfg.group} -"
      "d ${gitlabConfig.production.shared.path} 0750 ${cfg.user} ${cfg.group} -"
      "d ${gitlabConfig.production.shared.path}/artifacts 0750 ${cfg.user} ${cfg.group} -"
      "d ${gitlabConfig.production.shared.path}/lfs-objects 0750 ${cfg.user} ${cfg.group} -"
      "d ${gitlabConfig.production.shared.path}/packages 0750 ${cfg.user} ${cfg.group} -"
      "d ${gitlabConfig.production.shared.path}/pages 0750 ${cfg.user} ${cfg.group} -"
      "d ${gitlabConfig.production.shared.path}/terraform_state 0750 ${cfg.user} ${cfg.group} -"
      "L+ /run/gitlab/config - - - - ${cfg.statePath}/config"
      "L+ /run/gitlab/log - - - - ${cfg.statePath}/log"
      "L+ /run/gitlab/tmp - - - - ${cfg.statePath}/tmp"
      "L+ /run/gitlab/uploads - - - - ${cfg.statePath}/uploads"

      "L+ /run/gitlab/shell-config.yml - - - - ${pkgs.writeText "config.yml" (builtins.toJSON gitlabShellConfig)}"
    ];


    systemd.services.gitlab-config = {
      wantedBy = [ "gitlab.target" ];
      partOf = [ "gitlab.target" ];
      path = with pkgs; [
        jq
        openssl
        replace-secret
        git
      ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "infinity";
        Restart = "on-failure";
        WorkingDirectory = "${cfg.packages.gitlab}/share/gitlab";
        RemainAfterExit = true;

        ExecStartPre = let
          preStartFullPrivileges = ''
            set -o errexit -o pipefail -o nounset
            shopt -s dotglob nullglob inherit_errexit

            chown --no-dereference '${cfg.user}':'${cfg.group}' '${cfg.statePath}'/*
            if [[ -n "$(ls -A '${cfg.statePath}'/config/)" ]]; then
              chown --no-dereference '${cfg.user}':'${cfg.group}' '${cfg.statePath}'/config/*
            fi
          '';
        in "+${pkgs.writeShellScript "gitlab-pre-start-full-privileges" preStartFullPrivileges}";

        ExecStart = pkgs.writeShellScript "gitlab-config" ''
          set -o errexit -o pipefail -o nounset
          shopt -s inherit_errexit

          umask u=rwx,g=rx,o=

          cp -f ${cfg.packages.gitlab}/share/gitlab/VERSION ${cfg.statePath}/VERSION
          rm -rf ${cfg.statePath}/db/*
          rm -f ${cfg.statePath}/lib
          find '${cfg.statePath}/config/' -maxdepth 1 -mindepth 1 -type d -execdir rm -rf {} \;
          cp -rf --no-preserve=mode ${cfg.packages.gitlab}/share/gitlab/config.dist/* ${cfg.statePath}/config
          cp -rf --no-preserve=mode ${cfg.packages.gitlab}/share/gitlab/db/* ${cfg.statePath}/db
          ln -sf ${extraGitlabRb} ${cfg.statePath}/config/initializers/extra-gitlab.rb

          ${cfg.packages.gitlab-shell}/bin/install

          ${optionalString cfg.smtp.enable ''
              install -m u=rw ${smtpSettings} ${cfg.statePath}/config/initializers/smtp_settings.rb
              ${optionalString (cfg.smtp.passwordFile != null) ''
                  replace-secret '@smtpPassword@' '${cfg.smtp.passwordFile}' '${cfg.statePath}/config/initializers/smtp_settings.rb'
              ''}
          ''}

          (
            umask u=rwx,g=,o=

            openssl rand -hex 32 > ${cfg.statePath}/gitlab_shell_secret

            rm -f '${cfg.statePath}/config/database.yml'

            ${if cfg.databasePasswordFile != null then ''
                db_password="$(<'${cfg.databasePasswordFile}')"
                export db_password

                if [[ -z "$db_password" ]]; then
                  >&2 echo "Database password was an empty string!"
                  exit 1
                fi

                jq <${pkgs.writeText "database.yml" (builtins.toJSON databaseConfig)} \
                   '.${if lib.versionAtLeast (lib.getVersion cfg.packages.gitlab) "15.0" then "production.main" else "production"}.password = $ENV.db_password' \
                   >'${cfg.statePath}/config/database.yml'
              ''
              else ''
                jq <${pkgs.writeText "database.yml" (builtins.toJSON databaseConfig)} \
                   >'${cfg.statePath}/config/database.yml'
              ''
            }

            ${utils.genJqSecretsReplacementSnippet
                gitlabConfig
                "${cfg.statePath}/config/gitlab.yml"
            }

            rm -f '${cfg.statePath}/config/secrets.yml'

            secret="$(<'${cfg.secrets.secretFile}')"
            db="$(<'${cfg.secrets.dbFile}')"
            otp="$(<'${cfg.secrets.otpFile}')"
            jws="$(<'${cfg.secrets.jwsFile}')"
            export secret db otp jws
            jq -n '{production: {secret_key_base: $ENV.secret,
                    otp_key_base: $ENV.otp,
                    db_key_base: $ENV.db,
                    openid_connect_signing_key: $ENV.jws}}' \
               > '${cfg.statePath}/config/secrets.yml'
          )

          # We remove potentially broken links to old gitlab-shell versions
          rm -Rf ${cfg.statePath}/repositories/**/*.git/hooks

          git config --global core.autocrlf "input"
        '';
      };
    };

    systemd.services.gitlab-db-config = {
      after = [ "gitlab-config.service" "gitlab-postgresql.service" "postgresql.service" ];
      bindsTo = [
        "gitlab-config.service"
      ] ++ optional (cfg.databaseHost == "") "postgresql.service"
        ++ optional databaseActuallyCreateLocally "gitlab-postgresql.service";
      wantedBy = [ "gitlab.target" ];
      partOf = [ "gitlab.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "infinity";
        Restart = "on-failure";
        WorkingDirectory = "${cfg.packages.gitlab}/share/gitlab";
        RemainAfterExit = true;

        ExecStart = pkgs.writeShellScript "gitlab-db-config" ''
          set -o errexit -o pipefail -o nounset
          shopt -s inherit_errexit
          umask u=rwx,g=rx,o=

          initial_root_password="$(<'${cfg.initialRootPasswordFile}')"
          ${gitlab-rake}/bin/gitlab-rake gitlab:db:configure GITLAB_ROOT_PASSWORD="$initial_root_password" \
                                                             GITLAB_ROOT_EMAIL='${cfg.initialRootEmail}' > /dev/null
        '';
      };
    };

    systemd.services.gitlab-sidekiq = {
      after = [
        "network.target"
        "redis-gitlab.service"
        "postgresql.service"
        "gitlab-config.service"
        "gitlab-db-config.service"
      ];
      bindsTo = [
        "redis-gitlab.service"
        "gitlab-config.service"
        "gitlab-db-config.service"
      ] ++ optional (cfg.databaseHost == "") "postgresql.service";
      wantedBy = [ "gitlab.target" ];
      partOf = [ "gitlab.target" ];
      environment = gitlabEnv // (optionalAttrs cfg.sidekiq.memoryKiller.enable {
        SIDEKIQ_MEMORY_KILLER_MAX_RSS = cfg.sidekiq.memoryKiller.maxMemory;
        SIDEKIQ_MEMORY_KILLER_GRACE_TIME = cfg.sidekiq.memoryKiller.graceTime;
        SIDEKIQ_MEMORY_KILLER_SHUTDOWN_WAIT = cfg.sidekiq.memoryKiller.shutdownWait;
      });
      path = with pkgs; [
        postgresqlPackage
        gitPackage
        ruby
        openssh
        nodejs
        gnupg

        # Needed for GitLab project imports
        gnutar
        gzip

        procps # Sidekiq MemoryKiller
      ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "infinity";
        Restart = "always";
        WorkingDirectory = "${cfg.packages.gitlab}/share/gitlab";
        ExecStart="${cfg.packages.gitlab.rubyEnv}/bin/sidekiq -C \"${cfg.packages.gitlab}/share/gitlab/config/sidekiq_queues.yml\" -e production";
      };
    };

    systemd.services.gitaly = {
      after = [ "network.target" "gitlab-config.service" ];
      bindsTo = [ "gitlab-config.service" ];
      wantedBy = [ "gitlab.target" ];
      partOf = [ "gitlab.target" ];
      path = with pkgs; [
        openssh
        procps  # See https://gitlab.com/gitlab-org/gitaly/issues/1562
        gitPackage
        cfg.packages.gitaly.rubyEnv
        cfg.packages.gitaly.rubyEnv.wrappedRuby
        gzip
        bzip2
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

    systemd.services.gitlab-pages = mkIf (gitlabConfig.production.pages.enabled or false) {
      description = "GitLab static pages daemon";
      after = [ "network.target" "gitlab-config.service" ];
      bindsTo = [ "gitlab-config.service" ];
      wantedBy = [ "gitlab.target" ];
      partOf = [ "gitlab.target" ];

      path = [ pkgs.unzip ];

      serviceConfig = {
        Type = "simple";
        TimeoutSec = "infinity";
        Restart = "on-failure";

        User = cfg.user;
        Group = cfg.group;

        ExecStart = "${cfg.packages.pages}/bin/gitlab-pages ${escapeShellArgs pagesArgs}";
        WorkingDirectory = gitlabEnv.HOME;
      };
    };

    systemd.services.gitlab-workhorse = {
      after = [ "network.target" ];
      wantedBy = [ "gitlab.target" ];
      partOf = [ "gitlab.target" ];
      path = with pkgs; [
        exiftool
        gitPackage
        gnutar
        gzip
        openssh
        gitlab-workhorse
      ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "infinity";
        Restart = "on-failure";
        WorkingDirectory = gitlabEnv.HOME;
        ExecStart =
          "${cfg.packages.gitlab-workhorse}/bin/workhorse "
          + "-listenUmask 0 "
          + "-listenNetwork unix "
          + "-listenAddr /run/gitlab/gitlab-workhorse.socket "
          + "-authSocket ${gitlabSocket} "
          + "-documentRoot ${cfg.packages.gitlab}/share/gitlab/public "
          + "-secretPath ${cfg.statePath}/.gitlab_workhorse_secret";
      };
    };

    systemd.services.gitlab-mailroom = mkIf (gitlabConfig.production.incoming_email.enabled or false) {
      description = "GitLab incoming mail daemon";
      after = [ "network.target" "redis-gitlab.service" "gitlab-config.service" ];
      bindsTo = [ "gitlab-config.service" ];
      wantedBy = [ "gitlab.target" ];
      partOf = [ "gitlab.target" ];
      environment = gitlabEnv;
      serviceConfig = {
        Type = "simple";
        TimeoutSec = "infinity";
        Restart = "on-failure";

        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.packages.gitlab.rubyEnv}/bin/bundle exec mail_room -c ${cfg.statePath}/config/mail_room.yml";
        WorkingDirectory = gitlabEnv.HOME;
      };
    };

    systemd.services.gitlab = {
      after = [
        "gitlab-workhorse.service"
        "network.target"
        "redis-gitlab.service"
        "gitlab-config.service"
        "gitlab-db-config.service"
      ];
      bindsTo = [
        "redis-gitlab.service"
        "gitlab-config.service"
        "gitlab-db-config.service"
      ] ++ optional (cfg.databaseHost == "") "postgresql.service";
      wantedBy = [ "gitlab.target" ];
      partOf = [ "gitlab.target" ];
      environment = gitlabEnv;
      path = with pkgs; [
        postgresqlPackage
        gitPackage
        openssh
        nodejs
        procps
        gnupg
      ];
      serviceConfig = {
        Type = "notify";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "infinity";
        Restart = "on-failure";
        WorkingDirectory = "${cfg.packages.gitlab}/share/gitlab";
        ExecStart = concatStringsSep " " [
          "${cfg.packages.gitlab.rubyEnv}/bin/puma"
          "-e production"
          "-C ${cfg.statePath}/config/puma.rb"
          "-w ${cfg.puma.workers}"
          "-t ${cfg.puma.threadsMin}:${cfg.puma.threadsMax}"
        ];
      };

    };

    systemd.services.gitlab-backup = {
      after = [ "gitlab.service" ];
      bindsTo = [ "gitlab.service" ];
      startAt = cfg.backup.startAt;
      environment = {
        RAILS_ENV = "production";
        CRON = "1";
      } // optionalAttrs (stringLength cfg.backup.skip > 0) {
        SKIP = cfg.backup.skip;
      };
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${gitlab-rake}/bin/gitlab-rake gitlab:backup:create";
      };
    };

  };

  meta.doc = ./gitlab.xml;

}
