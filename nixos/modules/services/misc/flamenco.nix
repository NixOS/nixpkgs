{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.flamenco;
  yaml = pkgs.formats.yaml {};
  roleIs = role: lib.any (x: x == role) cfg.role;
  defaultConfig = {
    manager = {
      _meta = {version = 3;};
      manager_name = "Flamenco";
      autodiscoverable = true;
      shaman = {
        enabled = true;
        garbageCollect = {
          period = "24h0m0s";
          maxAge = "7440m0s";
          extraCheckoutPaths = [];
        };
      };
      task_timeout = "10m0s";
      worker_timeout = "1m0s";
      blocklist_threshold = 3;
      task_fail_after_softfail_count = 3;
      variables = {
        "blender" = {
          values = [
            {
              platform = "linux";
              value = "blender";
            }
            {
              platform = "windows";
              value = "blender";
            }
            {
              platform = "darwin";
              value = "blender";
            }
          ];
        };

        "blenderArgs" = {
          values = [
            {
              platform = "all";
              value = "-b -y";
            }
          ];
        };
      };
    };

    worker = {
      task_types = ["blender" "ffmpeg" "file-managerment" "misc"];
      restart_exit_code = 47;
    };
  };

  configFile = {
    manager = yaml.generate "flamenco-manager.yaml" (defaultConfig.manager // cfg.managerConfig // {
      # Flamenco manager config accepts this as relative path ONLY
      local_manager_storage_path = "../../../../${cfg.managerConfig.local_manager_storage_path}";
      listen = cfg.listen.ip + ":" + (toString cfg.listen.port);
    });
    worker = yaml.generate "flamenco-worker.yaml" (defaultConfig.worker // cfg.workerConfig);
  };

  mkService = role: {
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];
    description = "flamenco ${role}";
    environment =
      if (role == "worker")
      then {
        FLAMENCO_HOME = cfg.home;
        FLAMENCO_WORKER_NAME =
          if (!builtins.isNull cfg.workerConfig.worker_name)
          then cfg.workerConfig.worker_name
          else null;
      }
      else {};

    serviceConfig = {
      ExecStart = "${cfg.package}/bin/flamenco-${role}";

      User = cfg.user;
      Group = cfg.group;
      StateDirectory = "flamenco";
      StateDirectoryMode = "0755";
      WorkingDirectory = "${pkgs.linkFarm "flamenco-${role}-wd" [
        {
          name = "flamenco-${role}.yaml";
          path = "${configFile.${role}}";
        }
      ]}";

      RestartForceExitStatus =
        if (role == "worker")
        then cfg.workerConfig.restart_exit_code
        else null;
      Restart = "on-failure";
    };
  };
in {
  meta.maintainers = with lib.maintainers; [ hubble ];

  options.services.flamenco = with lib.types; {
    enable = lib.mkEnableOption "Flamenco, a render farm management software for Blender";
    package = lib.mkPackageOption pkgs "flamenco" {};
    openFirewall = lib.mkEnableOption "service ports in the firewall";

    role = lib.mkOption {
      description = "Flamenco role that this machine should take.";
      default = ["worker"];
      type = listOf (enum ["manager" "worker"]);
    };

    user = lib.mkOption {
      description = "User under which flamenco runs under.";
      default = "render";
      type = str;
    };

    group = lib.mkOption {
      description = "Group under which flamenco runs under.";
      default = "render";
      type = str;
    };

    home = lib.mkOption {
      description = "Directory for worker-specific files.";
      default = "${cfg.stateDir}/worker";
      defaultText = "$\{config.services.flamenco.stateDir\}/worker";
      type = path;
    };

    listen = lib.mkOption {
      description = "IP and port flamenco binds to.";
      type = submodule {
        options = {
          ip = lib.mkOption {
            default = "";
            description = "The IP flamenco listens to.";
            type = str;
          };
          port = lib.mkOption {
            default = 8080;
            description = "The port flamenco listens to";
            type = int;
          };
        };
      };
    };

    managerConfig = lib.mkOption {
      description = "Manager configuration";
      default = defaultConfig.manager;
      type = submodule {
        freeformType = attrsOf anything;
        options = {
          autodiscoverable = lib.mkOption {
            description = "Use UPnP/SSDP to advertise manager.";
            default = true;
            type = bool;
          };
          manager_name = lib.mkOption {
            description = "The name of the Manager.";
            default = "Flamenco Manager";
            type = str;
          };
          database = lib.mkOption {
            description = "Path of the database";
            default = "${cfg.stateDir}/flamenco-manager.sqlite";
            defaultText = "$\{config.services.flamenco.stateDir\}/flamenco-manager.sqlite";
            type = path;
          };
          shared_storage_path = lib.mkOption {
            description = "Path of shared storage, used to store project files and output";
            default = "/srv/flamenco";
            type = path;
          };
          local_manager_storage_path = lib.mkOption {
            description = "Path for Flamenco manager state files";
            default = "${cfg.stateDir}/flamenco-manager-storage";
            defaultText = "$\{config.services.flamenco.stateDir\}/flamenco-manager-storage";
            type = path;
          };
        };
      };
    };

    workerConfig = lib.mkOption {
      description = "Worker configuration";
      default = defaultConfig.worker;
      type = submodule {
        freeformType = attrsOf anything;
        options = {
          worker_name = lib.mkOption {
            description = "The name of the Worker. If not specified, the worker will use the hostname.";
            default = null;
            type = nullOr str;
          };
          manager_url = lib.mkOption {
            description = "The URL of the Manager to connect to. If the setting is blank (or removed altogether) the Worker will try to auto-detect the Manager on the network.";
            default = null;
            type = nullOr str;
          };
          restart_exit_code = lib.mkOption {
            description = "Having this set to a non-zero value will mark this Worker as ‘restartable’.";
            default = 47;
            type = int;
          };
        };
      };
    };

    stateDir = lib.mkOption {
      description = "Specifies the directory in which flamenco state files and credentials reside.";
      default = "/var/lib/flamenco";
      type = path;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    networking.firewall = lib.optionalAttrs (cfg.openFirewall && roleIs "manager") {
      allowedTCPPorts = [(cfg.listen.port)];
      allowedUDPPorts = lib.optionals (cfg.managerConfig.autodiscoverable) [1900];
    };

    systemd = {
      services = {
        flamenco-manager = lib.optionalAttrs (roleIs "manager") (mkService "manager");
        flamenco-worker = lib.optionalAttrs (roleIs "worker") (mkService "worker");
      };
    };

    users = {
      users = lib.optionalAttrs (cfg.user == "render" && cfg.group == "render") {
        "${cfg.user}" = {
          uid = config.ids.uids.render;
          group = cfg.group;
          isSystemUser = true;
        };
      };
    };
  };
}
