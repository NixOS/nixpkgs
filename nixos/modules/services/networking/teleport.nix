{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.teleport;

  # Pretty-print JSON to a file
  writePrettyJSON = name: x:
    pkgs.runCommand name { }
    "\n      echo '${builtins.toJSON x}' | ${pkgs.jq}/bin/jq . > $out\n    ";
  # This becomes the main config file
  telConfig = {
    teleport = {
      nodename = cfg.nodename;
      auth_token = cfg.auth_token;
      auth_servers = cfg.auth_servers;
      auth_service = cfg.auth_service;
      ssh_service = cfg.ssh_service;
      proxy_service = cfg.proxy_service;
    };
  };

  generatedTeleportYml = writePrettyJSON "teleport.yaml" telConfig;

  teleportYml = if cfg.configText != null then
    pkgs.writeText "teleport.yml" cfg.configText
  else
    generatedTeleportYml;

  cmdlineArgs = "-c ${teleportYml} --pid-file=/run/teleport.pid";

  telTypes.auth_service = {
    enabled = mkOption {
      type = types.str;
      default = "off";
    };
    cluster_name = mkOption {
      type = types.str;
      default = "";
    };
    authentication = {
      type = mkOption {
        type = types.str;
        default = "local";
      };
      second_factor = mkOption {
        type = types.str;
        default = "otp";
      };
    };
    listen_addr = mkOption {
      type = types.str;
      default = "";
    };
    public_addr = mkOption {
      type = types.str;
      default = "";
    };
    tokens = mkOption {
      type = types.listOf types.str;
      default = [ "" ];
    };
    session_recording = mkOption {
      type = types.str;
      default = "node";
    };
    client_idle_timeout = mkOption {
      type = types.str;
      default = "1hr";
    };
    disconnect_expired_cert = mkOption {
      type = types.str;
      default = "yes";
    };
    keep_alive_interval = mkOption {
      type = types.int;
      default = 15;
    };
    keep_alive_count_max = mkOption {
      type = types.int;
      default = 3;
    };
  };
  telTypes.ssh_service = {
    enabled = mkOption {
      type = types.str;
      default = "on";
    };
    listen_addr = mkOption {
      type = types.str;
      default = "0.0.0.0:3022";
    };
    public_addr = mkOption {
      type = types.str;
      default = "";
    };
    permit_user_env = mkOption {
      type = types.bool;
      default = false;
    };
    pam = {
      enabled = mkOption {
        type = types.bool;
        default = false;
      };
      service_name = mkOption {
        type = types.str;
        default = "sshd";
      };
    };
  };
  telTypes.proxy_service = {
    enabled = mkOption {
      type = types.str;
      default = "off";
    };
    listen_addr = mkOption {
      type = types.str;
      default = "";
    };
    web_listen_addr = mkOption {
      type = types.str;
      default = "";
    };
    tunnel_listen_addr = mkOption {
      type = types.str;
      default = "";
    };
    https_key_file = mkOption {
      type = types.str;
      default = "";
    };
    https_cert_file = mkOption {
      type = types.str;
      default = "";
    };
  };
  
in {
  options = {
    services.teleport = {
      enable = mkEnableOption "Teleport Cluster";
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/teleport";
        description = "Directory to store Teleport Service data";
      };
      configText = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = "If non-null, this option defines the text that is written to teleport.yml";
      };
      nodename = mkOption {
        type = types.str;
        default = "";
      };
      auth_token = mkOption {
        type = types.str;
        default = "";
      };
      auth_servers = mkOption {
        type = types.listOf types.str;
        default = [ "" ];
        description = "";
      };
      advertise_ip = mkOption {
        type = types.str;
        default = "";
      };
      connection_limits = {
        max_connection = mkOption {
          type = types.int;
          default = 1000;
        };
        max_users = mkOption {
          type = types.int;
          default = 250;
        };
      };
      inherit (telTypes) ssh_service auth_service proxy_service;
    };
  };
  
  config = mkIf cfg.enable {
    systemd.services.teleport = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.teleport}/bin/teleport start ${cmdlineArgs}";
        ExecReload = "/run/current-system/sw/bin/kill -HUP $MAINPID";
        PIDFile = "teleport.pid";
        Restart = "on-failure";
        WorkingDirectory = cfg.dataDir;
      };
    };
  };
}
