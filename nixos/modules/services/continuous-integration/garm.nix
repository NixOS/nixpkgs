{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.garm;

  format = pkgs.formats.toml { };

  # garm can't read secrets from files or the environment. Settings declared
  # as { _secret = "/path/to/file"; } are rendered into the config as a
  # placeholder, which is substituted with the file's content on startup.
  isSecret = v: lib.isAttrs v && v ? _secret && lib.isString v._secret;

  redactSecrets =
    v:
    if isSecret v then
      lib.hashString "sha256" v._secret
    else if lib.isDerivation v then
      v
    else if lib.isAttrs v then
      lib.mapAttrs (_: redactSecrets) v
    else if lib.isList v then
      map redactSecrets v
    else
      v;

  collectSecrets =
    v:
    if isSecret v then
      [ v._secret ]
    else if lib.isDerivation v then
      [ ]
    else if lib.isAttrs v then
      lib.concatMap collectSecrets (lib.attrValues v)
    else if lib.isList v then
      lib.concatMap collectSecrets v
    else
      [ ];

  secretPaths = lib.unique (collectSecrets cfg.settings);

  configFile = format.generate "garm-config.toml" (redactSecrets cfg.settings);

  defaultPort = 9997;

  # Binding the API to a privileged port needs additional capability.
  capabilities = lib.optional (cfg.settings.apiserver.port < 1024) "CAP_NET_BIND_SERVICE";
in

{
  options.services.garm = {
    enable = lib.mkEnableOption "GARM, a self-hosted runner manager for GitHub Actions and Gitea Actions";

    package = lib.mkPackageOption pkgs "garm" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          apiserver.bind = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = ''
              Address the API server binds to. Runner instances fetch their
              metadata from it and report back to it, so it has to be reachable
              from wherever the provider creates them.
            '';
          };
          apiserver.port = lib.mkOption {
            type = lib.types.port;
            default = defaultPort;
            description = "Port the API server listens on.";
          };
          database.backend = lib.mkOption {
            type = lib.types.str;
            default = "sqlite3";
            description = "Database backend to use.";
          };
          database.sqlite3.db_file = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/garm/garm.db";
            description = "Location of the SQLite database.";
          };
          jwt_auth.time_to_live = lib.mkOption {
            type = lib.types.str;
            default = "8760h";
            description = "Lifetime of the tokens issued to runner instances.";
          };
        };
      };
      default = { };
      example = lib.literalExpression ''
        {
          apiserver.bind = "0.0.0.0";
          jwt_auth.secret._secret = "/run/keys/garm-jwt-secret";
          database.passphrase._secret = "/run/keys/garm-db-passphrase";
          provider = [
            {
              name = "incus";
              description = "Incus external provider";
              provider_type = "external";
              external = {
                provider_executable = lib.getExe pkgs.garm-provider-incus;
                config_file = "/etc/garm/incus-provider.toml";
              };
            }
          ];
        }
      '';
      description = ''
        Configuration for GARM, rendered to {file}`config.toml`. See
        <https://github.com/cloudbase/garm/blob/main/doc/configuration.md>
        for available settings. At least `jwt_auth.secret` and
        `database.passphrase` must be set.

        Settings containing secret data should be set to an attribute set
        containing the attribute `_secret = "/path/to/secret"`, where that
        file contains the actual value. Secret files are loaded through
        systemd credentials, so they only need to be readable by root.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings.jwt_auth ? secret;
        message = "services.garm.settings.jwt_auth.secret must be set.";
      }
      {
        assertion = cfg.settings.database ? passphrase;
        message = "services.garm.settings.database.passphrase must be set.";
      }
    ];

    # Contains garm-cli, needed to manage the deployment.
    environment.systemPackages = [ cfg.package ];

    systemd.services.garm = {
      description = "GitHub Actions Runner Manager (garm)";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      preStart = ''
        install -m 0600 ${configFile} "$RUNTIME_DIRECTORY/config.toml"
      ''
      # Substitute the quoted placeholder with the secret encoded as a TOML
      # basic string, so that characters like " or \ in it can't break the
      # config. JSON string escaping emits a valid TOML string, quotes included.
      + lib.concatMapStrings (
        path:
        let
          plHolder = lib.hashString "sha256" path;
        in
        ''
          ${lib.getExe pkgs.jq} --raw-input --slurp 'rtrimstr("\n")' \
            < "$CREDENTIALS_DIRECTORY/${plHolder}" > "$RUNTIME_DIRECTORY/secret"
          ${lib.getExe pkgs.replace-secret} '"${plHolder}"' \
            "$RUNTIME_DIRECTORY/secret" "$RUNTIME_DIRECTORY/config.toml"
          rm "$RUNTIME_DIRECTORY/secret"
        ''
      ) secretPaths;
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} -config %t/garm/config.toml";
        DynamicUser = true;
        StateDirectory = "garm";
        RuntimeDirectory = "garm";
        RuntimeDirectoryMode = "0700";
        LoadCredential = map (path: "${lib.hashString "sha256" path}:${path}") secretPaths;
        Restart = "on-failure";

        # Hardening.
        AmbientCapabilities = capabilities;
        CapabilityBoundingSet = capabilities;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };
  };

  meta = {
    doc = ./garm.md;
    maintainers = with lib.maintainers; [ katexochen ];
  };
}
