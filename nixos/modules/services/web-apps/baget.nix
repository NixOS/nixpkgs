{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.baget;

  defaultConfig = {
    "PackageDeletionBehavior" = "Unlist";
    "AllowPackageOverwrites" = false;

    "Database" = {
      "Type" = "Sqlite";
      "ConnectionString" = "Data Source=baget.db";
    };

    "Storage" = {
      "Type" = "FileSystem";
      "Path" = "";
    };

    "Search" = {
      "Type" = "Database";
    };

    "Mirror" = {
      "Enabled" = false;
      "PackageSource" = "https://api.nuget.org/v3/index.json";
    };

    "Logging" = {
      "IncludeScopes" = false;
      "Debug" = {
        "LogLevel" = {
          "Default" = "Warning";
        };
      };
      "Console" = {
        "LogLevel" = {
          "Microsoft.Hosting.Lifetime" = "Information";
          "Default" = "Warning";
        };
      };
    };
  };

  configAttrs = recursiveUpdate defaultConfig cfg.extraConfig;

  configFormat = pkgs.formats.json {};
  configFile = configFormat.generate "appsettings.json" configAttrs;

in
{
  options.services.baget = {
    enable = mkEnableOption "BaGet NuGet-compatible server";

    apiKeyFile = mkOption {
      type = types.path;
      example = "/root/baget.key";
      description = ''
        Private API key for BaGet.
      '';
    };

    extraConfig = mkOption {
      type = configFormat.type;
      default = {};
      example = {
        "Database" = {
          "Type" = "PostgreSql";
          "ConnectionString" = "Server=/run/postgresql;Port=5432;";
        };
      };
      defaultText = literalExpression ''
        {
          "PackageDeletionBehavior" = "Unlist";
          "AllowPackageOverwrites" = false;

          "Database" = {
            "Type" = "Sqlite";
            "ConnectionString" = "Data Source=baget.db";
          };

          "Storage" = {
            "Type" = "FileSystem";
            "Path" = "";
          };

          "Search" = {
            "Type" = "Database";
          };

          "Mirror" = {
            "Enabled" = false;
            "PackageSource" = "https://api.nuget.org/v3/index.json";
          };

          "Logging" = {
            "IncludeScopes" = false;
            "Debug" = {
              "LogLevel" = {
                "Default" = "Warning";
              };
            };
            "Console" = {
              "LogLevel" = {
                "Microsoft.Hosting.Lifetime" = "Information";
                "Default" = "Warning";
              };
            };
          };
        }
      '';
      description = ''
        Extra configuration options for BaGet. Refer to <link xlink:href="https://loic-sharma.github.io/BaGet/configuration/"/> for details.
        Default value is merged with values from here.
      '';
    };
  };

  # implementation

  config = mkIf cfg.enable {

    systemd.services.baget = {
      description = "BaGet server";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network.target" "network-online.target" ];
      path = [ pkgs.jq ];
      serviceConfig = {
        WorkingDirectory = "/var/lib/baget";
        DynamicUser = true;
        StateDirectory = "baget";
        StateDirectoryMode = "0700";
        LoadCredential = "api_key:${cfg.apiKeyFile}";

        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        PrivateMounts = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectProc = "noaccess";
        ProcSubset = "pid";
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        SystemCallFilter = [ "@system-service" "~@privileged" ];
      };
      script = ''
        jq --slurpfile apiKeys <(jq -R . "$CREDENTIALS_DIRECTORY/api_key") '.ApiKey = $apiKeys[0]' ${configFile} > appsettings.json
        ln -snf ${pkgs.baget}/lib/BaGet/wwwroot wwwroot
        exec ${pkgs.baget}/bin/BaGet
      '';
    };

  };
}
