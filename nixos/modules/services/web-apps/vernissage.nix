{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib)
    filterAttrs
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    removePrefix
    ;

  inherit (lib.types)
    either
    enum
    listOf
    nullOr
    path
    port
    str
    submodule
    ;

  cfgApi = config.services.vernissage.api;
  cfgWeb = config.services.vernissage.web;
  cfgPush = config.services.vernissage.push;

  dataDir = "/var/lib/vernissage";

  format = pkgs.formats.json { };

  secret = submodule {
    options = {
      _secret = mkOption {
        type = path;
        description = ''
          Path to a file containing the secret.
        '';
      };
    };
  };

  loadCredentialsIntoEnv =
    credentials:
    lib.concatMapAttrsStringSep "\n" (
      name: _: ''export ${name}="$(systemd-creds cat ${name})"''
    ) credentials;
  loadCredentials = credentials: lib.mapAttrsToList (name: path: "${name}:${path}") credentials;

  vernissage_push_credentials = {
    VPUSH_KEY = cfgPush.vpushKeyFile;
  };
in
{
  options.services.vernissage = {
    api = {
      enable = mkEnableOption "Whether to enable the Vernissage API server.";
      package = mkPackageOption pkgs "vernissage-server" { };

      hostname = mkOption {
        type = str;
        default = "::";
        description = "Hostname the API listens on.";
      };
      port = mkOption {
        type = port;
        default = 8080;
        apply = toString;
        description = "Port the API listens on.";
      };
      logLevel = mkOption {
        type = enum [
          "trace"
          "debug"
          "info"
          "notice"
          "warning"
          "error"
          "critical"
        ];
        default = "notice";
        description = "API log level.";
      };

      settings = mkOption {
        type = submodule {
          freeformType = format.type;

          options = {
            baseAddress = mkOption {
              type = str;
              description = "Public base URL of the instance. Important for federation and links.";
            };
            connectionString = mkOption {
              type = either str secret;
              default = "/var/lib/vernissage/vernissage.db";
              description = "SQLite file path or PostgreSQL connection string.";
            };
            queueUrl = mkOption {
              type = nullOr (either str secret);
              example = "redis://127.0.0.1:6379";
              description = "Redis connection string used for queues and cache.";
            };
            s3Address = mkOption {
              type = nullOr str;
              description = "Base URL of S3-compatible storage.";
            };
            s3Region = mkOption {
              type = nullOr str;
              description = "AWS region. When set, AWS S3 settings take precedence over custom S3 address handling.";
            };
            s3Bucket = mkOption {
              type = nullOr str;
              description = "S3 bucket name for uploaded media.";
            };
            s3AccessKeyId = mkOption {
              type = nullOr (either str secret);
              example = ''
                {
                    _secret = /run/keys/vernissage-s3-id;
                }
              '';
              description = "S3 bucket access key id.";
            };
            s3SecretAccessKey = mkOption {
              type = nullOr (either str secret);
              example = ''
                {
                    _secret = /run/keys/vernissage-s3-secret;
                }
              '';
              description = "S3 bucket secret access key.";
            };
          };
        };
        description = ''
          Vernissage API configuration. Refer to [upstream documentation](https://github.com/VernissageApp/VernissageServer/#configuration) for more information.
          You can specify secret values in this configuration by setting `somevalue._secret = "/path/to/file"` instead of setting `somevalue` directly.
        '';
      };
    };

    web = {
      enable = mkEnableOption "Whether to enable the Vernissage web frontend.";
      package = mkPackageOption pkgs "vernissage-web" { };

      port = mkOption {
        type = port;
        default = 4200;
        description = "Port the web frontend listens on.";
      };

      settings = mkOption {
        type = submodule {
          freeformType = format.type;

          options = {
            cspImg = mkOption {
              type = nullOr str;
              example = "https://s3.eu-central-1.amazonaws.com";
              description = "Extends the `Content-Security-Policy` header for remote image loading.";
            };
            allowedHosts = mkOption {
              type = listOf str;
              example = [
                "yourdomain.photos"
                "*.otherdomain.social"
              ];
              description = "Specify allowed hosts for SSRF protection.";
            };
          };
        };
        description = ''
          Vernissage web frontend configuration. Refer to [upstream documentation](https://github.com/VernissageApp/VernissageWeb/#security-headers] for more information.
        '';
      };
    };

    push = {
      enable = mkEnableOption "Whether to enable the Vernissage push services.";
      package = mkPackageOption pkgs "vernissage-push" { };

      vpushKeyFile = mkOption {
        type = path;
        description = ''
          Path to a file containing the VPUSH key.
        '';
      };
    };
  };

  config = lib.mkMerge [
    (mkIf cfgApi.enable {
      assertions = [
        {
          assertion =
            (
              cfgApi.settings.s3Address != null
              && cfgApi.settings.s3Bucket != null
              && cfgApi.settings.s3AccessKeyId != null
              && cfgApi.settings.s3SecretAccessKey != null
            )
            || (
              cfgApi.settings.s3Address == null
              && cfgApi.settings.s3Bucket == null
              && cfgApi.settings.s3AccessKeyId == null
              && cfgApi.settings.s3SecretAccessKey == null
            );
          message = ''
            <option>services.vernissage.api.settings.s3Address</option>, <option>services.vernissage.api.settings.s3Bucket</option>, <option>services.vernissage.api.settings.s3AccessKeyIdFile</option> and <option>services.vernissage.api.settings.s3SecretAccessKeyFile</option> must all be set, as soon as one of them is set.
          '';
        }
      ];

      systemd.services.vernissage-server = {
        description = "Vernissage API service";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network-online.target"
        ];
        wants = [
          "network-online.target"
        ];

        preStart = ''
          # Generate config including secret values.
          ${utils.genJqSecretsReplacementSnippet {
            vernissage = (filterAttrs (n: v: v != null) cfgApi.settings);
          } "/run/vernissage/appsettings.json"}

          # Setup symlinks
          ln -sTf /run/vernissage/appsettings.json ${dataDir}/appsettings.json
          ln -sTf ${cfgApi.package}/Resources ${dataDir}/Resources

          # Setup dirs
          mkdir -p ${dataDir}/Public/storage ${dataDir}/Temp
        '';

        serviceConfig = {
          ExecStart = "${lib.getExe cfgApi.package} serve --env production --hostname ${cfgApi.hostname} --port ${cfgApi.port}";
          DynamicUser = true;

          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          StateDirectory = "vernissage";
          BindReadOnlyPaths = [
            "/nix/store"
          ];
          CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateUsers = true;
          PrivateMounts = true;
          PrivateTmp = true;
          PrivateDevices = true;
          DevicePolicy = "closed";
          ProcSubset = "pid";
          ProtectSystem = "strict";
          ProtectClock = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RuntimeDirectory = "vernissage";
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
          ];
          WorkingDirectory = dataDir;
        };

        environment = {
          LOG_LEVEL = cfgApi.logLevel;
        };
      };
    })
    (mkIf cfgWeb.enable {
      systemd.services.vernissage-web = {
        description = "Vernissage Web service";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network-online.target"
        ];
        wants = [
          "network-online.target"
        ];

        serviceConfig = {
          ExecStart = lib.getExe cfgWeb.package;
          DynamicUser = true;

          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          BindReadOnlyPaths = [
            "/nix/store"
          ];
          CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateUsers = true;
          PrivateMounts = true;
          PrivateTmp = true;
          PrivateDevices = true;
          DevicePolicy = "closed";
          ProcSubset = "pid";
          ProtectSystem = "strict";
          ProtectClock = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
          ];
        };

        environment = {
          PORT = toString cfgWeb.port;
          VERNISSAGE_CSP_IMG = cfgWeb.settings.cspImg;
          VERNISSAGE_ALLOWED_HOSTS = toString cfgWeb.settings.allowedHosts;
        };
      };
    })
    (mkIf (cfgApi.enable && cfgWeb.enable) {
      services.vernissage.web.settings.allowedHosts = [
        (removePrefix "https://" (removePrefix "http://" cfgApi.settings.baseAddress))
      ];
    })
    (mkIf (cfgApi.enable && cfgWeb.enable && cfgApi.settings.s3Address != null) {
      services.vernissage.web.settings.cspImg = cfgApi.settings.s3Address;
    })
    (mkIf cfgPush.enable {
      systemd.services.vernissage-push = {
        description = "Vernissage Push service";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network-online.target"
        ];
        wants = [
          "network-online.target"
        ];

        script = ''
          ${loadCredentialsIntoEnv vernissage_push_credentials}

          ${lib.getExe cfgPush.package}
        '';

        serviceConfig = {
          DynamicUser = true;

          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          BindReadOnlyPaths = [
            "/nix/store"
          ];
          CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
          LoadCredential = loadCredentials vernissage_push_credentials;
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateUsers = true;
          PrivateMounts = true;
          PrivateTmp = true;
          PrivateDevices = true;
          DevicePolicy = "closed";
          ProcSubset = "pid";
          ProtectSystem = "strict";
          ProtectClock = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
          ];
        };

        environment = {
          PORT = toString cfgWeb.port;
          VERNISSAGE_CSP_IMG = cfgWeb.settings.cspImg;
          VERNISSAGE_ALLOWED_HOSTS = toString cfgWeb.settings.allowedHosts;
        };
      };
    })
  ];

  meta.maintainers = with lib.maintainers; [ Cameo007 ];
}
