{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.concourse-worker;
  useContainerd = cfg.runtime.type == "containerd";
  useGuardian = cfg.runtime.type == "guardian";
in
{
  meta.maintainers = with lib.maintainers; [ lenianiva ];

  options.services.concourse-worker = {
    enable = lib.mkEnableOption "A container-based automation system written in Go. (The worker part)";
    package = lib.mkPackageOption pkgs [ "concourse" "executable" ] { };
    auto-restart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically restart failed servers";
    };
    tag = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Tag for this worker";
    };
    team = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Team for this worker";
    };
    work-dir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/concourse";
      description = "Work directory, which should be backed by sufficient storage.";
    };
    resource-types = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to advertised resource types";
    };
    tsa = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1:2222";
        description = "Host";
      };
      public-key = lib.mkOption {
        type = lib.types.str;
        description = "Public key";
      };
      worker-private-key = lib.mkOption {
        type = lib.types.str;
        description = "Private key for this worker";
      };
    };
    p2p = {
      bind-ip = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "IP for P2P Worker Volume Sharing";
      };
      interface-name-pattern = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Regex to match a network interface";
      };
      interface-family = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "4";
        description = "Set to 4 for IPv4 interface, 6 for IPv6";
      };
    };
    runtime = {
      type = lib.mkOption {
        type = lib.types.enum [
          "containerd"
          "guardian"
          "houdini"
        ];
        default = "containerd";
        description = "Container runtimes type.";
      };
      bin = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Path to runtime server executable";
      };
      dns-server = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "DNS Server for the runtime";
      };
      config = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Path to a config file for the backend";
      };
    };
    args = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Extra options to pass to concourse executable";
    };
    environment = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.str;
      example = lib.literalExpression ''
        {
          CONCOURSE_CONTAINERD_DNS_SERVER="1.1.1.1,8.8.8.8";
        }
      '';
      description = "Concourse web server environment variables [documentation](https://concourse-ci.org/concourse-worker.html#web-running)";
    };
    environmentFile = lib.mkOption {
      type = with lib.types; coercedTo path (f: [ f ]) (listOf path);
      default = [ ];
      example = [ "/root/concourse-worker.env" ];
      description = ''
        File to load environment variables
        from. This is helpful for specifying secrets.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {
      concourse-worker = {
        description = "Concourse CI worker";
        after = [
          "network.target"
          "local-fs.target"
          "dbus.service"
        ];
        wantedBy = [ "multi-user.target" ];
        path = [
          pkgs.util-linux
          pkgs.iptables
          pkgs.gnutar
          pkgs.gzip
          pkgs.runc
        ]
        # From `containerd`
        ++ lib.optional config.boot.zfs.enabled config.boot.zfs.package;
        serviceConfig = {
          # Worker must be run as root, because it needs to launch containers
          #WorkingDirectory = cfg.work-dir;
          StateDirectory = cfg.work-dir;
          StateDirectoryMode = "0777";
          #UMask = "0007";
          ConfigurationDirectory = "concourse-worker";
          EnvironmentFile = cfg.environmentFile;
          ExecStart = "${cfg.package}/bin/concourse worker ${cfg.args}";
          Restart = if cfg.auto-restart then "on-failure" else "no";
          RestartSec = 15;

          # From containerd
          Delegate = "yes";
          LimitNPROC = "infinity";
          LimitCORE = "infinity";
          TasksMax = "infinity";
          OOMScoreAdjust = "-999";
          #CapabilityBoundingSet = "";
          # Security
          #NoNewPrivileges = true;
          ## Sandboxing
          #ProtectSystem = "full";
          #ProtectHome = true;
          #PrivateTmp = true;
          #PrivateDevices = true;
          #PrivateUsers = true;
          #ProtectHostname = true;
          #ProtectClock = true;
          #ProtectKernelTunables = true;
          #ProtectKernelModules = true;
          #ProtectKernelLogs = true;
          #LockPersonality = true;
          #MemoryDenyWriteExecute = true;
          #RestrictRealtime = true;
          #RestrictSUIDSGID = true;
          #PrivateMounts = true;

          #RestrictAddressFamilies = [ "AF_UNIX AF_INET AF_INET6" ];

          # Do not filter control groups and system calls since this needs to run a container runtime
          #ProtectControlGroups = true;
          #SystemCallArchitectures = "native";
          #SystemCallFilter = "~@clock @privileged @cpu-emulation @debug @keyring @module @mount @obsolete @raw-io @reboot @setuid @swap";
        };
        environment = {
          CONCOURSE_WORK_DIR = cfg.work-dir;
          CONCOURSE_TAG = cfg.tag;
          CONCOURSE_TEAM = cfg.team;

          CONCOURSE_TSA_HOST = cfg.tsa.host;
          CONCOURSE_TSA_PUBLIC_KEY = cfg.tsa.public-key;
          CONCOURSE_TSA_WORKER_PRIVATE_KEY = cfg.tsa.worker-private-key;

          CONCOURSE_BAGGAGECLAIM_BIND_IP = cfg.p2p.bind-ip;
          CONCOURSE_BAGGAGECLAIM_P2P_INTERFACE_NAME_PATTERN = cfg.p2p.interface-name-pattern;
          CONCOURSE_BAGGAGECLAIM_P2P_INTERFACE_FAMILY = cfg.p2p.interface-family;

          CONCOURSE_RUNTIME = cfg.runtime.type;
          CONCOURSE_RESOURCE_TYPES = lib.defaultTo "${pkgs.concourse.resource-types}" cfg.resource-types;
        }
        // lib.ifEnable useContainerd {
          CONCOURSE_CONTAINERD_BIN = lib.defaultTo "${pkgs.containerd}/bin/containerd" cfg.runtime.bin;
          CONCOURSE_CONTAINERD_INIT_BIN = "${pkgs.concourse.init}/init";
          CONCOURSE_CONTAINERD_CONFIG = cfg.runtime.config;
          CONCOURSE_CONTAINERD_DNS_SERVER = cfg.runtime.dns-server;
          CONCOURSE_CONTAINERD_CNI_PLUGINS_DIR = "${pkgs.cni-plugins}/bin";
        }
        // lib.ifEnable useGuardian {
          CONCOURSE_GARDEN_BIN = cfg.runtime.bin;
          CONCOURSE_GARDEN_CONFIG = cfg.runtime.config;
          CONCOURSE_GARDEN_DNS_SERVER = cfg.runtime.dns-server;
        }
        // cfg.environment;
      };
    };
  };

}
