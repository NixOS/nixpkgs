{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.n8n;

  # Partition environment variables into regular and file-based (_FILE suffix)
  envVarToCredName = varName: lib.toLower varName;
  partitionEnv =
    allEnv:
    let
      env = lib.filterAttrs (_name: value: value != null) allEnv;
      regular = lib.filterAttrs (name: _value: !(lib.hasSuffix "_FILE" name)) env;
      fileBased = lib.filterAttrs (name: _value: lib.hasSuffix "_FILE" name) env;
      fileBasedTransformed = lib.mapAttrs' (
        varName: _secretPath: lib.nameValuePair varName "%d/${envVarToCredName varName}"
      ) fileBased;
    in
    {
      inherit regular fileBased fileBasedTransformed;
    };

  n8nEnv = partitionEnv cfg.environment;

  customNodesDir = pkgs.linkFarm "n8n-custom-nodes" (
    map (pkg: {
      name = pkg.pname;
      path = "${pkg}/lib/node_modules/${pkg.pname}";
    }) cfg.customNodes
  );

  # Runners
  runnersCfg = cfg.taskRunners;
  runnersEnv = partitionEnv runnersCfg.environment;
  commonAllowedEnv = lib.attrNames runnersEnv.regular;
  enabledRunners = lib.filterAttrs (_name: runnerCfg: runnerCfg.enable) runnersCfg.runners;
  anyRunnerEnabled = runnersCfg.enable && (enabledRunners != { });
  runnerTypes = lib.attrNames enabledRunners;
  runnersStateDir = "n8n-task-runners";
  taskRunnerConfigs = lib.mapAttrsToList (runnerType: runnerCfg: {
    runner-type = runnerType;
    workdir = "/var/lib/${runnersStateDir}";
    command = runnerCfg.command;
    args = runnerCfg.args;
    allowed-env = commonAllowedEnv;
    env-overrides = runnerCfg.environment;
    health-check-server-port = toString runnerCfg.healthCheckPort;
  }) enabledRunners;

  launcherConfigFile = pkgs.writeText "n8n-task-runners.json" (
    builtins.toJSON { task-runners = taskRunnerConfigs; }
  );
in
{
  meta.maintainers = with lib.maintainers; [
    sweenu
    gepbird
  ];

  imports = [
    (lib.mkRemovedOptionModule [ "services" "n8n" "settings" ] "Use services.n8n.environment instead.")
    (lib.mkRemovedOptionModule [
      "services"
      "n8n"
      "webhookUrl"
    ] "Use services.n8n.environment.WEBHOOK_URL instead.")
  ];

  options.services.n8n = {
    enable = lib.mkEnableOption "n8n server";

    package = lib.mkPackageOption pkgs "n8n" { };

    customNodes = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.n8n-nodes-carbonejs ]";
      description = ''
        List of custom n8n community node packages to load.
        Each package is expected to be an npm package with an `n8n.nodes` entry in its `package.json`.
        The packages are made available to n8n via the `N8N_CUSTOM_EXTENSIONS` environment variable.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open ports in the firewall for the n8n web interface.";
    };

    environment = lib.mkOption {
      description = ''
        Environment variables to pass to the n8n service.
        See <https://docs.n8n.io/hosting/configuration/environment-variables/> for available options.

        Environment variables ending with `_FILE` are automatically handled as secrets:
        they are loaded via systemd credentials for secure access with `DynamicUser=true`.

        This can be useful to pass secrets via tools like `agenix` or `sops-nix`.
      '';
      example = lib.literalExpression ''
        {
          N8N_ENCRYPTION_KEY_FILE = "/run/n8n/encryption_key";
          DB_POSTGRESDB_PASSWORD_FILE = "/run/n8n/db_postgresdb_password";
          WEBHOOK_URL = "https://n8n.example.com";
        }
      '';
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            str
            (coercedTo int toString str)
            (coercedTo bool builtins.toJSON str)
          ]);
        options = {
          GENERIC_TIMEZONE = lib.mkOption {
            type = with lib.types; nullOr str;
            default = config.time.timeZone;
            defaultText = lib.literalExpression "config.time.timeZone";
            description = ''
              The n8n instance timezone. Important for schedule nodes (such as Cron).
            '';
          };
          N8N_PORT = lib.mkOption {
            type = with lib.types; coercedTo port toString str;
            default = 5678;
            description = "The HTTP port n8n runs on.";
          };
          N8N_USER_FOLDER = lib.mkOption {
            type = lib.types.path;
            # This folder must be writeable as the application is storing
            # its data in it, so the StateDirectory is a good choice
            default = "/var/lib/n8n";
            description = ''
              Provide the path where n8n will create the .n8n folder.
              This directory stores user-specific data, such as database file and encryption key.
            '';
            readOnly = true;
          };
          N8N_DIAGNOSTICS_ENABLED = lib.mkOption {
            type = with lib.types; coercedTo bool builtins.toJSON str;
            default = false;
            description = ''
              Whether to share selected, anonymous telemetry with n8n.
              Note that if you set this to false, you can't enable Ask AI in the Code node.
            '';
          };
          N8N_VERSION_NOTIFICATIONS_ENABLED = lib.mkOption {
            type = with lib.types; coercedTo bool builtins.toJSON str;
            default = false;
            description = ''
              When enabled, n8n sends notifications of new versions and security updates.
            '';
          };
          N8N_CUSTOM_EXTENSIONS = lib.mkOption {
            internal = true;
            type = with lib.types; nullOr path;
            default = if cfg.customNodes != [ ] then toString customNodesDir else null;
            description = ''
              Specify the path to directories containing your custom nodes.
            '';
          };
          N8N_RUNNERS_MODE = lib.mkOption {
            internal = true;
            type =
              with lib.types;
              enum [
                "internal"
                "external"
              ];
            default = if runnersCfg.enable then "external" else "internal";
            description = ''
              How to launch and run the task runner.
              `internal` means n8n will launch a task runner as child process.
              `external` means an external orchestrator will launch the task runner.
            '';
          };
          N8N_RUNNERS_BROKER_PORT = lib.mkOption {
            type = with lib.types; coercedTo port toString str;
            default = 5679;
            description = ''
              Port the task broker listens on for task runner connections.
            '';
          };
          N8N_RUNNERS_BROKER_LISTEN_ADDRESS = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = ''
              Address the task broker listens on.
            '';
          };
          N8N_RUNNERS_AUTH_TOKEN_FILE = lib.mkOption {
            type = with lib.types; nullOr path;
            default = null;
            description = ''
              Path to a file containing the shared authentication token
              used between the n8n server (task broker) and the task runners.

              This option is required when {option}`services.n8n.taskRunners.enable` is true.
              The file should be readable by the service and not stored in the Nix store.
              Use tools like `agenix` or `sops-nix` to manage this secret.
            '';
          };
        };
      };
      default = { };
    };

    taskRunners = {
      enable = lib.mkEnableOption "n8n task runners for sandboxed Code node execution";

      launcherPackage = lib.mkPackageOption pkgs "n8n-task-runner-launcher" { };

      environment = lib.mkOption {
        description = ''
          Environment variables for the task runner launcher and runners.
          These are common to all runners and passed via `allowed-env` in the launcher config.
          See <https://docs.n8n.io/hosting/configuration/environment-variables/task-runners/> for available options.

          Environment variables ending with `_FILE` are automatically handled as secrets:
          they are loaded via systemd credentials for secure access with `DynamicUser=true`.

          Note: The authentication token should be set via {option}`services.n8n.environment.N8N_RUNNERS_AUTH_TOKEN_FILE`.
        '';
        example = lib.literalExpression ''
          {
            N8N_RUNNERS_AUTO_SHUTDOWN_TIMEOUT = 15;
            N8N_RUNNERS_MAX_CONCURRENCY = 10;
          }
        '';
        type = lib.types.submodule {
          freeformType =
            with lib.types;
            attrsOf (oneOf [
              str
              (coercedTo int toString str)
              (coercedTo bool builtins.toJSON str)
            ]);
          options = {
            N8N_RUNNERS_AUTH_TOKEN_FILE = lib.mkOption {
              type = with lib.types; nullOr path;
              default = cfg.environment.N8N_RUNNERS_AUTH_TOKEN_FILE;
              defaultText = lib.literalExpression "config.services.n8n.environment.N8N_RUNNERS_AUTH_TOKEN_FILE";
              description = ''
                Path to the authentication token file for the task runner.
              '';
            };
            N8N_RUNNERS_TASK_BROKER_URI = lib.mkOption {
              type = lib.types.str;
              default = "http://${cfg.environment.N8N_RUNNERS_BROKER_LISTEN_ADDRESS}:${cfg.environment.N8N_RUNNERS_BROKER_PORT}";
              defaultText = lib.literalExpression ''"http://''${config.services.n8n.environment.N8N_RUNNERS_BROKER_LISTEN_ADDRESS}:''${config.services.n8n.environment.N8N_RUNNERS_BROKER_PORT}"'';
              description = ''
                URI of the n8n task broker that the runner connects to.
              '';
            };
          };
        };
        default = { };
      };

      runners = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = ''
                    Whether to enable the ${name} task runner.
                    Only takes effect when {option}`services.n8n.taskRunners.enable` is true.
                  '';
                };

                command = lib.mkOption {
                  type = lib.types.str;
                  description = "Command to execute for this runner.";
                };

                healthCheckPort = lib.mkOption {
                  type = lib.types.port;
                  description = "Port for the runner's health check server.";
                };

                args = lib.mkOption {
                  type = with lib.types; listOf str;
                  default = [ ];
                  description = "Additional command-line arguments to pass to the task runner.";
                };

                environment = lib.mkOption {
                  type = with lib.types; attrsOf str;
                  default = { };
                  description = "Environment variables specific to this task runner.";
                };
              };
            }
          )
        );
        default = { };
        defaultText = lib.literalExpression ''
          {
            javascript = {
              enable = true;
              command = lib.getExe' config.services.n8n.package "n8n-task-runner";
              healthCheckPort = 5681;
            };
            python = {
              enable = true;
              command = lib.getExe' config.services.n8n.package "n8n-task-runner-python";
              healthCheckPort = 5682;
            };
          }
        '';
        description = "Configuration for individual task runners.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = anyRunnerEnabled -> cfg.environment.N8N_RUNNERS_AUTH_TOKEN_FILE != null;
        message = "services.n8n.environment.N8N_RUNNERS_AUTH_TOKEN_FILE must be set when task runners are enabled.";
      }
    ];

    systemd.services.n8n = {
      description = "n8n service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment =
        n8nEnv.regular
        // {
          HOME = cfg.environment.N8N_USER_FOLDER;
        }
        // n8nEnv.fileBasedTransformed;
      serviceConfig = {
        Type = "simple";
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        StateDirectory = baseNameOf cfg.environment.N8N_USER_FOLDER;

        LoadCredential = lib.mapAttrsToList (
          varName: secretPath: "${envVarToCredName varName}:${secretPath}"
        ) n8nEnv.fileBased;

        # Basic Hardening
        NoNewPrivileges = "yes";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        DevicePolicy = "closed";
        DynamicUser = "true";
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ProtectControlGroups = "yes";
        ProtectKernelModules = "yes";
        ProtectKernelTunables = "yes";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        RestrictNamespaces = "yes";
        RestrictRealtime = "yes";
        RestrictSUIDSGID = "yes";
        MemoryDenyWriteExecute = "no"; # v8 JIT requires memory segments to be Writable-Executable.
        LockPersonality = "yes";
      };
    };

    warnings = lib.optional (runnersCfg.enable && !anyRunnerEnabled) ''
      services.n8n.taskRunners.enable is true, but both JavaScript and Python runners are disabled.
      Enable at least one runner or disable taskRunners.
    '';

    # We set the defaults here to ease adding attributes
    services.n8n.taskRunners.runners = {
      javascript = lib.mapAttrs (_: lib.mkDefault) {
        enable = true;
        command = lib.getExe' cfg.package "n8n-task-runner";
        healthCheckPort = 5681;
      };
      python = lib.mapAttrs (_: lib.mkDefault) {
        enable = true;
        command = lib.getExe' cfg.package "n8n-task-runner-python";
        healthCheckPort = 5682;
      };
    };

    systemd.services.n8n-task-runner = lib.mkIf anyRunnerEnabled {
      description = "n8n task runner";
      after = [ "n8n.service" ];
      requires = [ "n8n.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        N8N_RUNNERS_CONFIG_PATH = launcherConfigFile;
      }
      // runnersEnv.regular
      // runnersEnv.fileBasedTransformed;
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe runnersCfg.launcherPackage} ${lib.concatStringsSep " " runnerTypes}";
        Restart = "on-failure";

        StateDirectory = runnersStateDir;

        LoadCredential = lib.mapAttrsToList (
          varName: secretPath: "${envVarToCredName varName}:${secretPath}"
        ) runnersEnv.fileBased;

        # Hardening
        DynamicUser = "true";
        NoNewPrivileges = "yes";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        DevicePolicy = "closed";
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ProtectControlGroups = "yes";
        ProtectKernelModules = "yes";
        ProtectKernelTunables = "yes";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        RestrictNamespaces = "yes";
        RestrictRealtime = "yes";
        RestrictSUIDSGID = "yes";
        MemoryDenyWriteExecute = "no"; # v8 JIT requires memory segments to be Writable-Executable.
        LockPersonality = "yes";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ (lib.toInt cfg.environment.N8N_PORT) ];
    };
  };
}
