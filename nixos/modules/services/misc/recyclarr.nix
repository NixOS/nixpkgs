{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.recyclarr;
  format = pkgs.formats.yaml { };
  stateDir = "/var/lib/recyclarr";
  configPath = "${stateDir}/config.yml";
  secretsReplacement = utils.genJqSecretsReplacement {
    loadCredential = true;
  } cfg.configuration configPath;
  settingsPath = "${stateDir}/settings.yml";
in
{
  options.services.recyclarr = {
    enable = lib.mkEnableOption "recyclarr service";

    package = lib.mkPackageOption pkgs "recyclarr" { };

    configuration = lib.mkOption {
      type = format.type;
      default = { };
      example = {
        sonarr = {
          sonarr-main = {
            instance_name = "main";
            base_url = "http://localhost:8989";
            api_key = {
              _secret = "/run/credentials/recyclarr.service/sonarr-api_key";
            };
          };
        };
        radarr = {
          radarr-main = {
            instance_name = "main";
            base_url = "http://localhost:7878";
            api_key = {
              _secret = "/run/credentials/recyclarr.service/radarr-api_key";
            };
          };
        };
      };
      description = ''
        Recyclarr YAML configuration as a Nix attribute set.

        For detailed configuration options and examples, see the
        [official configuration reference](https://recyclarr.dev/wiki/yaml/config-reference/).

        The configuration is processed using [utils.genJqSecretsReplacement](https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/utils.nix#L232-L331) to handle secret substitution.
        ```
      '';
    };

    settings = lib.mkOption {
      type = format.type;
      default = { };
      example = {
        enable_ssl_certificate_validation = true;
        git_path = lib.literalExpression "\${lib.getExe pkgs.git}";

        log_janitor = {
          max_files = 20;
        };

        notifications = {
          verbosity = "normal";
          apprise = {
            mode = "stateful";
            base_url = "http://localhost:8000";
            key = "recyclarr";
            tags = "foo bar, baz";
          };
        };

        resource_providers = [
          # Git-based provider (trash-guides or config-templates)
          {
            name = "trash_guides";
            type = "trash-guides";
            clone_url = "https://github.com/TRaSH-/Guides.git";
            reference = "master";
            replace_default = true;
          }
          {
            name = "config-templates";
            type = "config-templates";
            clone_url = "https://github.com/recyclarr/config-templates.git";
            reference = "master";
            replace_default = true;
          }
          # Local directory provider (custom-formats)
          {
            name = "my-language-cfs";
            type = "custom-formats";
            path = lib.literalExpression "./path/to/custom-radarr-formats";
            service = "radarr";
            replace_default = false;
          }
        ];
      };
      description = ''
        Recyclarr YAML settings as a Nix attribute set.

        For detailed settings options and examples, see the
        [official settings reference](https://recyclarr.dev/reference/settings/).
      '';
    };

    schedule = lib.mkOption {
      type = lib.types.str;
      default = "daily";
      description = "When to run recyclarr in systemd calendar format.";
    };

    command = lib.mkOption {
      type = lib.types.str;
      default = "sync";
      description = "The recyclarr command to run (e.g., sync).";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "recyclarr";
      description = "User account under which recyclarr runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "recyclarr";
      description = "Group under which recyclarr runs.";
    };
  };

  config = lib.mkIf cfg.enable {

    users.users = lib.mkIf (cfg.user == "recyclarr") {
      recyclarr = {
        isSystemUser = true;
        description = "recyclarr user";
        home = stateDir;
        group = cfg.group;
      };
    };

    users.groups = lib.mkIf (cfg.group == "recyclarr") {
      ${cfg.group} = { };
    };

    systemd.services.recyclarr = {
      description = "Recyclarr Service";

      preStart = ''
        ${secretsReplacement.script}
        ${pkgs.coreutils}/bin/ln -fs ${format.generate "settings.yaml" cfg.settings} ${settingsPath}
      '';

      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "recyclarr";
        Environment = [
          "RECYCLARR_CONFIG_DIR=${stateDir}"
          "RECYCLARR_DATA_DIR=${stateDir}"
        ];
        ExecStart = "${lib.getExe cfg.package} ${cfg.command} --config ${configPath}";
        LoadCredential = secretsReplacement.credentials;

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;

        PrivateNetwork = false;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];

        NoNewPrivileges = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;

        ReadWritePaths = [ stateDir ];

        CapabilityBoundingSet = "";

        LockPersonality = true;
        RestrictRealtime = true;
      };
    };

    systemd.timers.recyclarr = {
      description = "Recyclarr Timer";
      wantedBy = [ "timers.target" ];
      partOf = [ "recyclarr.service" ];

      timerConfig = {
        OnCalendar = cfg.schedule;
        Persistent = true;
        RandomizedDelaySec = "5m";
      };
    };
  };

  meta.maintainers = [ lib.maintainers.josephst ];
}
