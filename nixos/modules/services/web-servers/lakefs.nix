{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionalString
    recursiveUpdate
    types
    ;

  cfg = config.services.lakefs;
  yaml = pkgs.formats.yaml { };

  defaultUser = "lakefs";
  authEncryptSecretKeyPath =
    if cfg.secrets.authEncryptSecretKeyFile != null then
      cfg.secrets.authEncryptSecretKeyFile
    else
      "${cfg.stateDir}/auth_encrypt_secret_key";
  blockstoreSigningSecretKeyPath =
    if cfg.secrets.blockstoreSigningSecretKeyFile != null then
      cfg.secrets.blockstoreSigningSecretKeyFile
    else
      "${cfg.stateDir}/blockstore_signing_secret_key";

  effectiveSettings = recursiveUpdate {
    listen_address = "${cfg.host}:${toString cfg.port}";

    logging = {
      format = "text";
      level = "INFO";
      output = "-";
    };

    database = {
      type = "local";
      local.path = "${cfg.stateDir}/metadata";
    };

    blockstore = {
      type = "local";
      local.path = "${cfg.stateDir}/blockstore";
    };

    stats.enabled = false;
    usage_report.enabled = false;
  } cfg.settings;

  configFile = yaml.generate "lakefs.yaml" effectiveSettings;

  managedDirs =
    let
      collect = path: optional (path != "") path;
    in
    lib.unique (
      [ cfg.stateDir ]
      ++ collect (effectiveSettings.database.local.path or "")
      ++ collect (effectiveSettings.blockstore.local.path or "")
    );
in
{
  meta.maintainers = with lib.maintainers; [ philocalyst ];

  options.services.lakefs = {
    enable = mkEnableOption "lakeFS server";

    package = mkPackageOption pkgs "lakefs" { };

    user = mkOption {
      type = types.str;
      default = defaultUser;
      description = "User account under which lakeFS runs.";
    };

    group = mkOption {
      type = types.str;
      default = defaultUser;
      description = "Group under which lakeFS runs.";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/lakefs";
      example = "/srv/lakefs";
      description = "State directory for lakeFS local data and generated secrets.";
    };

    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      example = "127.0.0.1";
      description = "Host address for lakeFS to listen on by default.";
    };

    port = mkOption {
      type = types.port;
      default = 8000;
      description = "Port for lakeFS to listen on by default.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall for the configured lakeFS HTTP port.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = yaml.type;
      };
      default = { };
      description = ''
        lakeFS server configuration written to `config.yaml`. See the upstream
        configuration reference at
        <https://docs.lakefs.io/latest/reference/configuration/>.

        By default this module configures lakeFS to use local storage under
        {option}`services.lakefs.stateDir`. Secret values should preferably be
        supplied through {option}`services.lakefs.environmentFile` or
        {option}`services.lakefs.secrets` instead of being written directly
        into this option.
      '';
      example = lib.literalExpression ''
        {
          database = {
            type = "postgres";
            postgres.connection_string = "postgres://lakefs@localhost/lakefs?host=/run/postgresql";
          };

          blockstore = {
            type = "s3";
            s3 = {
              region = "us-east-1";
              endpoint = "http://127.0.0.1:9000";
              force_path_style = true;
              discover_bucket_region = false;
            };
          };
        }
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/lakefs";
      description = ''
        Environment file passed to the lakeFS systemd service. Useful for
        secret configuration values that should not be stored in the Nix store,
        such as `LAKEFS_DATABASE_POSTGRES_CONNECTION_STRING`.
      '';
    };

    extraEnvironment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Extra environment variables passed to the lakeFS service.";
    };

    secrets = mkOption {
      type = types.submodule {
        options = {
          authEncryptSecretKeyFile = mkOption {
            type = types.nullOr types.path;
            default = null;
            example = "/run/secrets/lakefs-auth-encrypt-secret-key";
            description = ''
              File containing the value for `auth.encrypt.secret_key`.

              When left as `null`, a random key is generated on first startup at
              `/var/lib/lakefs/auth_encrypt_secret_key` by default.
            '';
          };

          blockstoreSigningSecretKeyFile = mkOption {
            type = types.nullOr types.path;
            default = null;
            example = "/run/secrets/lakefs-blockstore-signing-secret-key";
            description = ''
              File containing the value for `blockstore.signing.secret_key`.

              When left as `null`, a random key is generated on first startup at
              `/var/lib/lakefs/blockstore_signing_secret_key` by default.
            '';
          };
        };
      };
      default = { };
      description = "Secret file configuration for required lakeFS keys.";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = optional cfg.openFirewall cfg.port;

    systemd.tmpfiles.rules = map (dir: "d '${dir}' 0750 ${cfg.user} ${cfg.group} - -") managedDirs;

    systemd.services.lakefs = {
      description = "lakeFS server";
      documentation = [ "https://docs.lakefs.io/latest/" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      restartTriggers = [ configFile ] ++ optional (cfg.environmentFile != null) cfg.environmentFile;
      environment = cfg.extraEnvironment;
      path = [ pkgs.openssl ];
      preStart = ''
        umask 0077
        ${optionalString (cfg.secrets.authEncryptSecretKeyFile == null) ''
          if [ ! -f ${lib.escapeShellArg authEncryptSecretKeyPath} ]; then
            openssl rand -hex 32 > ${lib.escapeShellArg authEncryptSecretKeyPath}
          fi
        ''}
        ${optionalString (cfg.secrets.blockstoreSigningSecretKeyFile == null) ''
          if [ ! -f ${lib.escapeShellArg blockstoreSigningSecretKeyPath} ]; then
            openssl rand -hex 32 > ${lib.escapeShellArg blockstoreSigningSecretKeyPath}
          fi
        ''}
      '';

      serviceConfig = {
        ExecStart = pkgs.writeShellScript "lakefs-start" ''
          set -eu
          if [ -z "''${LAKEFS_AUTH_ENCRYPT_SECRET_KEY:-}" ]; then
            export LAKEFS_AUTH_ENCRYPT_SECRET_KEY="$(cat ${lib.escapeShellArg authEncryptSecretKeyPath})"
          fi
          if [ -z "''${LAKEFS_BLOCKSTORE_SIGNING_SECRET_KEY:-}" ]; then
            export LAKEFS_BLOCKSTORE_SIGNING_SECRET_KEY="$(cat ${lib.escapeShellArg blockstoreSigningSecretKeyPath})"
          fi
          exec ${getExe cfg.package} run --config ${lib.escapeShellArg configFile}
        '';
        EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;
        WorkingDirectory = cfg.stateDir;
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
        UMask = "0077";
        LimitNOFILE = 65536;
        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
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
      }
      // lib.optionalAttrs (cfg.stateDir == "/var/lib/lakefs") {
        StateDirectory = "lakefs";
      };
    };

    users.users = mkIf (cfg.user == defaultUser) {
      lakefs = {
        group = cfg.group;
        home = cfg.stateDir;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == defaultUser) {
      lakefs = { };
    };
  };
}
