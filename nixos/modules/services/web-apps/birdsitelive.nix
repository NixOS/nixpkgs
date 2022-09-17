{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.birdsitelive;
  db = cfg.settings.Db;

  isAbsolutePath = v: isString v && substring 0 1 v == "/";
  isSecret = v: isAttrs v && v ? _secret && isAbsolutePath v._secret;

  secret = mkOptionType {
    name = "secret";
    description = "secret value";
    descriptionClass = "noun";
    check = isSecret;
    nestedTypes = {
      _secret = types.str;
    };
  };

  sha256 = builtins.hashString "sha256";

  toJsonSec = let
    concatItems = concatStringsSep ",";
    toJsonSec' = { }@args: v:
      if isAttrs v
        then if v ? _secret
          then if isAbsolutePath v._secret
            then ''"${sha256 v._secret}"''
            else abort "Invalid secret path (_secret = ${v._secret})"
          else "{${concatItems (mapAttrsToList (key: val: ''"${key}":${toJsonSec' args val}'') v)}}"
        else if isList v
          then "[${concatItems (map (toJsonSec' args) v)}]"
          else builtins.toJSON v;
  in toJsonSec' { };

  configFile = pkgs.runCommand "appsettings.json" {
    nativeBuildInputs = with pkgs; [ jq ];
    value = toJsonSec cfg.settings;
    passAsFile = [ "value" ];
  } ''jq . "$valuePath" >$out'';

  secretPaths = catAttrs "_secret" (collect isSecret cfg.settings);

  writeShell = { name, text, runtimeInputs ? [ ] }:
    pkgs.writeShellApplication { inherit name text runtimeInputs; } + "/bin/${name}";

  configScript = writeShell {
    name = "birdsitelive-config";
    runtimeInputs = with pkgs; [ coreutils replace-secret ];
    text = ''
      cd "$RUNTIME_DIRECTORY"
      tmp="$(mktemp appsettings.json.XXXXXXXXXX)"
      trap 'rm -f "$tmp"' INT TERM HUP EXIT

      cat ${escapeShellArg configFile} >"$tmp"
      ${concatMapStrings (file: ''
        replace-secret ${escapeShellArgs [ (sha256 file) file ]} "$tmp"
      '') secretPaths}

      chown ${escapeShellArg cfg.user}:${escapeShellArg cfg.group} "$tmp"
      chmod 0400 "$tmp"
      mv "$tmp" appsettings.json
    '';
  };

  managerConfigScript = writeShell {
    name = "bslmanager-config";
    runtimeInputs = with pkgs; [ coreutils jq ];
    text = ''
      cd "$RUNTIME_DIRECTORY"
      tmp="$(mktemp ManagerSettings.json.XXXXXXXXXX)"
      trap 'rm -f "$tmp"' INT TERM HUP EXIT

      jq '{
          "DbType": .Db.Type,
          "DbHost": .Db.Host,
          "DbUser": .Db.User,
          "DbPassword": .Db.Password,
          "InstanceDomain": .Instance.Domain
        }' appsettings.json \
        >"$tmp"

      chown ${escapeShellArg cfg.user}:${escapeShellArg cfg.group} "$tmp"
      chmod 0440 "$tmp"
      mv "$tmp" ManagerSettings.json
    '';
  };

  pgpass = let
    esc = escape [ ":" ''\'' ];
  in if (cfg.initDb.password != null)
    then pkgs.writeText "pgpass.conf" ''
      *:*:*${esc cfg.initDb.username}:${esc (sha256 cfg.initDb.password._secret)}
    ''
    else null;

  escapeSqlId = x: ''"${replaceStrings [ ''"'' ] [ ''""'' ] x}"'';
  escapeSqlStr = x: "'${replaceStrings [ "'" ] [ "''" ] x}'";

  setupSql = pkgs.writeText "setup.psql" ''
    \set ON_ERROR_STOP on

    ALTER ROLE ${escapeSqlId db.User}
      LOGIN PASSWORD ${if db.Password != null
        then "${escapeSqlStr (sha256 db.Password._secret)}"
        else "NULL"};

    ALTER DATABASE ${escapeSqlId db.Name}
      OWNER TO ${escapeSqlId db.User};
  '';

  initDbScript = writeShell {
    name = "birdsitelive-initdb";
    runtimeInputs = with pkgs; [ coreutils replace-secret config.services.postgresql.package ];
    text = ''
      pgpass="$(mktemp -t pgpass-XXXXXXXXXX.conf)"
      setupSql="$(mktemp -t setup-XXXXXXXXXX.psql)"
      trap 'rm -f "$pgpass $setupSql"' INT TERM HUP EXIT

      export PGHOST=${escapeShellArg db.Host}
      export PGUSER=${escapeShellArg cfg.initDb.username}
      ${optionalString (pgpass != null) ''
        cat ${escapeShellArg pgpass} >"$pgpass"
        replace-secret ${escapeShellArgs [
          (sha256 cfg.initDb.password._secret) cfg.initDb.password._secret ]} "$pgpass"
        export PGPASSFILE="$pgpass"
      ''}

      cat ${escapeShellArg setupSql} >"$setupSql"
      ${optionalString (db.Password != null) ''
        replace-secret ${escapeShellArgs [
        (sha256 db.Password._secret) db.Password._secret ]} "$setupSql"
      ''}

      # Create role if non‐existent
      psql -tAc "SELECT 1 FROM pg_roles
        WHERE rolname = "${escapeShellArg (escapeSqlStr db.User)} | grep -F -q 1 || \
        psql -tAc "CREATE ROLE "${escapeShellArg (escapeSqlId db.User)}

      # Create database if non‐existent
      psql -tAc "SELECT 1 FROM pg_database
        WHERE datname = "${escapeShellArg (escapeSqlStr db.Name)} | grep -F -q 1 || \
        psql -tAc "CREATE DATABASE "${escapeShellArg (escapeSqlId db.Name)}"
          OWNER "${escapeShellArg (escapeSqlId db.User)}"
          TEMPLATE template0
          ENCODING 'utf8'
          LOCALE 'C'"

      psql -f "$setupSql"
    '';
  };

  settingsType = (pkgs.formats.json { }).type;
  localDb = hasPrefix "/" db.Host;
in {
  options = {
    services.birdsitelive = {
      enable = mkEnableOption (mdDoc "BirdsiteLIVE");

      package = mkOption {
        type = types.package;
        default = pkgs.birdsitelive;
        defaultText = literalExpression "pkgs.birdsitelive";
        description = mdDoc "BirdsiteLIVE package to use.";
      };

      user = mkOption {
        type = types.nonEmptyStr;
        default = "birdsitelive";
        description = mdDoc "User account under which BirdsiteLIVE runs.";
      };

      group = mkOption {
        type = types.nonEmptyStr;
        default = "birdsitelive";
        description = mdDoc "Group account under which BirdsiteLIVE runs.";
      };

      initDb = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = mdDoc ''
            Whether to automatically initialise the database on startup. This will create a
            database role and database if they do not already exist, and (re)set the role password
            and the ownership of the database.

            The database settings are configured through
            {option}`config.services.birdsitelive.settings.Db`.

            If disabled, the database has to be set up manually:

            ```SQL
            CREATE ROLE birdsitelive LOGIN;

            CREATE DATABASE birdsitelive
              OWNER birdsitelive
              TEMPLATE template0
              ENCODING 'utf8'
              LOCALE 'C';
            ```
          '';
        };

        username = mkOption {
          type = types.nonEmptyStr;
          default = config.services.postgresql.superUser;
          defaultText = literalExpression "config.services.postgresql.superUser";
          description = mdDoc ''
            Name of the database user to initialise the database with.

            This user is required to have the `CREATEROLE` and `CREATEDB` capabilities.
          '';
        };

        password = mkOption {
          type = types.nullOr secret;
          default = null;
          description = mdDoc ''
            Password of the database user to initialise the database with.

            If set to `null`, no password will be used.

            The attribute `_secret` should point to a file containing the secret.
          '';
        };
      };

      settings = let
        concatOrNull = x:
          if x != [ ]
            then concatStringsSep ";" x
            else null;
      in mkOption {
        description = mdDoc ''
          Configuration for BirdsiteLIVE. The attributes are serialised to JSON.

          Refer to <https://github.com/NicolasConstant/BirdsiteLive/blob/master/VARIABLES.md>
          for details.

          Settings containing secret data should be set to an attribute set containing the
          attribute `_secret` - a string pointing to a file containing the value the option
          should be set to.
        '';

        type = types.submodule {
          freeformType = settingsType;
          options = {
            Logging = mkOption {
              type = settingsType;
              description = mdDoc ''
                Logging settings.

                Refer to
                <https://learn.microsoft.com/en-us/aspnet/core/fundamentals/logging/?view=aspnetcore-6.0>
                for configuration options.
              '';
              default = {
                Type = "none";
                InstrumentationKey = "key";
                ApplicationInsights = {
                  LogLevel = {
                    Default = "Warning";
                  };
                };
                LogLevel = {
                  Default = "Information";
                  Microsoft = "Warning";
                  "Microsoft.Hosting.Lifetime" = "Information";
                };
              };
            };

            AllowedHosts = mkOption {
              type = with types; listOf str;
              default = [
                "localhost"
                cfg.settings.Instance.Domain
              ];
              defaultText = literalExpression ''
                [
                  "localhost"
                  config.services.birdsitelive.settings.Instance.Domain
                ];
              '';
              description = mdDoc "List of allowed host name patterns.";
              apply = concatStringsSep ";";
            };

            Kestrel = mkOption {
              type = settingsType;
              description = mdDoc ''
                Kestrel web server settings.

                Refer to
                <https://learn.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel/endpoints?view=aspnetcore-6.0#configureiconfiguration-1>
                for configuration options.
              '';
              default = {
                Endpoints = {
                  Http = {
                    Url = "http://localhost:5000";
                  };
                };
              };
            };

            Instance = {
              Name = mkOption {
                type = types.nonEmptyStr;
                default = "BirdsiteLIVE";
                description = mdDoc "Instance name.";
              };

              Domain = mkOption {
                type = types.nonEmptyStr;
                default = config.networking.fqdn;
                defaultText = literalExpression "config.networking.fqdn";
                description = mdDoc "Domain name of the instance.";
              };

              AdminEmail = mkOption {
                type = types.nonEmptyStr;
                description = mdDoc "Instance administrator email address.";
              };

              ResolveMentionsInProfiles = mkOption {
                type = types.bool;
                default = true;
                description = mdDoc "Whether to enable mentions parsing in Twitter profile descriptions.";
              };

              PublishReplies = mkOption {
                type = types.bool;
                default = false;
                description = mdDoc "Whether to publish replies.";
              };

              UnlistedTwitterAccounts = mkOption {
                type = with types; listOf nonEmptyStr;
                default = [ ];
                description = mdDoc "List of Twitter account for which to enable unlisted publication.";
                apply = concatOrNull;
              };

              SensitiveTwitterAccounts = mkOption {
                type = with types; listOf nonEmptyStr;
                default = [ ];
                description = mdDoc "List of Twitter account to mark all media from as sensitive by default.";
                apply = concatOrNull;
              };

              FailingTwitterUserCleanUpThreshold = mkOption {
                type = types.ints.unsigned;
                default = 700;
                description = mdDoc "Maximum error count before auto-removal of a Twitter account.";
              };

              FailingFollowerCleanUpThreshold = mkOption {
                type = types.ints.unsigned;
                default = 30000;
                description = mdDoc "Maximum error count before auto-removal of a Fediverse account.";
              };

              UserCacheCapacity = mkOption {
                type = types.ints.unsigned;
                default = 10000;
                description = mdDoc "Caching limit for Twitter user retrieval.";
              };
            };

            Db = {
              Type = mkOption {
                type = types.nonEmptyStr;
                default = "postgres";
                visible = false;
                description = mdDoc "Database type.";
              };

              Host = mkOption {
                type = types.nonEmptyStr;
                default = "/run/postgresql";
                description = mdDoc "Database server hostname or socket.";
              };

              Name = mkOption {
                type = types.nonEmptyStr;
                default = "birdsitelive";
                description = mdDoc "Database name.";
              };

              User = mkOption {
                type = types.nonEmptyStr;
                default = cfg.user;
                defaultText = literalExpression "config.services.birdsitelive.user";
                description = mdDoc "Database user name.";
              };

              Password = mkOption {
                type = types.nullOr secret;
                default = null;
                description = mdDoc ''
                  Database user password.

                  The attribute `_secret` should point to a file containing the secret.
                '';
              };
            };

            Twitter = {
              ConsumerKey = mkOption {
                type = types.nonEmptyStr;
                description = mdDoc "Twitter API key";
              };

              ConsumerSecret = mkOption {
                type = secret;
                example = { _secret = "/run/keys/birdsitelive/api-secret"; };
                description = mdDoc ''
                  Twitter API secret";

                  The attribute `_secret` should point to a file containing the secret.
                '';
              };
            };

            Moderation = {
              FollowersWhiteListing = mkOption {
                type = with types; listOf nonEmptyStr;
                default = [ ];
                description = mdDoc "List of Fediverse user or instance patterns to allow as followers.";
                apply = concatOrNull;
              };

              FollowersBlackListing = mkOption {
                type = with types; listOf nonEmptyStr;
                default = [ ];
                description = mdDoc "List of Fediverse user or instance patterns to disallow as followers.";
                apply = concatOrNull;
              };

              TwitterAccountsWhiteListing = mkOption {
                type = with types; listOf nonEmptyStr;
                default = [ ];
                description = mdDoc "List of Twitter handles to allow following.";
                apply = concatOrNull;
              };

              TwitterAccountsBlackListing = mkOption {
                type = with types; listOf nonEmptyStr;
                default = [ ];
                description = mdDoc "List of Twitter handles to disallow following.";
                apply = concatOrNull;
              };
            };
          };
        };
      };

      nginx = mkOption {
        type = with types; nullOr (submodule
          (import ../web-servers/nginx/vhost-options.nix { inherit config lib; }));
        default = null;
        description = mdDoc ''
          Extra configuration for the nginx virtual hosts of BirdsiteLIVE.

          If set to `null`, no virtual host will be added to the nginx configuration.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    warnings = let mod = cfg.settings.Moderation; in
      optional (mod.FollowersWhiteListing != null && mod.FollowersBlackListing != null ||
        mod.TwitterAccountsWhiteListing != null && mod.TwitterAccountsBlackListing != null) ''
        If both both a whitelist and a blacklist are set for Fediverse or Twitter
        accounts, only the whitelist will be used.
      '';

    users = {
      users."${cfg.user}" = {
        description = "BirdsiteLIVE user";
        group = cfg.group;
        isSystemUser = true;
      };
      groups."${cfg.group}" = { };
    };

    # Confinement of the main service unit requires separation of the
    # configuration generation into a separate unit to permit access to secrets
    # residing outside of the chroot.
    systemd.services.birdsitelive-config = {
      description = "BirdsiteLIVE Twitter bridge configuration";
      reloadTriggers = [ configFile ] ++ secretPaths;

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        RuntimeDirectory = "birdsitelive";
        RuntimeDirectoryMode = "0750";

        ExecStart = [
          configScript
          "-${managerConfigScript}"
        ];
        ExecReload = [
          configScript
          "-${managerConfigScript}"
        ];
      };
    };

    systemd.services.birdsitelive-initdb = {
      description = "BirdsiteLIVE Twitter bridge database setup";
      requires = [ "birdsitelive-config.service" ];
      requiredBy = [ "birdsitelive.service" ];
      after = [ "birdsitelive-config.service" "postgresql.service" ];
      before = [ "birdsitelive.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        UMask = "0077";
        ExecStart = initDbScript;
        PrivateTmp = true;
      } // optionalAttrs localDb {
        User = cfg.initDb.username;
      };
    };

    systemd.services.birdsitelive = {
      description = "BirdsiteLIVE Twitter to ActivityPub bridge";
      documentation = [ "https://github.com/NicolasConstant/BirdsiteLive" ];

      # This service unit depends on network-online.target and is sequenced after
      # it because it requires access to the Internet to function properly.
      bindsTo = [ "birdsitelive-config.service" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      after = [
        "birdsitelive-config.service"
        "network.target"
        "network-online.target"
        "postgresql.service"
      ];

      confinement.packages = with pkgs; [ dotnetCorePackages.aspnetcore_3_1 ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        UMask = "0077";

        RuntimeDirectory = "birdsitelive";
        RuntimeDirectoryMode = "0750";
        RuntimeDirectoryPreserve = true;
        WorkingDirectory = "%t/birdsitelive";

        BindReadOnlyPaths = [
          "/etc/hosts" "/etc/resolv.conf"
          "-/run/postgresql"
          "${cfg.package}/lib/birdsitelive/wwwroot:%t/birdsitelive/wwwroot:norbind"
        ];

        ExecStart = "${cfg.package}/bin/BirdsiteLive";
        KillSignal = "SIGINT";

        ProtectProc = "noaccess";
        ProcSubset = "pid";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateIPC = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;

        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ]
          ++ optionals localDb [ "AF_UNIX" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;

        CapabilityBoundingSet =
          if any (port: port < 1024) (mapAttrsToList
            (name: val: toInt (last (splitString ":" val.Url)))
            cfg.settings.Kestrel.Endpoints)
          then [ "CAP_NET_BIND_SERVICE" ]
          else null;

        NoNewPrivileges = true;
        SystemCallFilter = [ "@system-service" "~@privileged" ];
        SystemCallArchitectures = "native";

        DeviceAllow = null;
        DevicePolicy = "closed";
        SocketBindAllow = mapAttrsToList
          (name: val: "tcp:${last (splitString ":" val.Url)}")
          cfg.settings.Kestrel.Endpoints;
        SocketBindDeny = "any";
      } // optionalAttrs (!config.systemd.services.birdsitelive.confinement.enable) {
        ProtectSystem = "strict";
      };
    };

    services.nginx.virtualHosts = mkIf (cfg.nginx != null) {
      ${cfg.settings.Instance.Domain} = mkMerge [ cfg.nginx {
        locations."/" = {
          proxyPass = last (mapAttrsToList (key: val: val.Url) cfg.settings.Kestrel.Endpoints);
          recommendedProxySettings = true;
        };
      }];
    };
  };

  meta.maintainers = with maintainers; [ mvs ];
}
