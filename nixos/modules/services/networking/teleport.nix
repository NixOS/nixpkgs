{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.teleport;

  # Pretty-print JSON to a file
  writePrettyJSON = name: x:
    pkgs.runCommand name { } "
      echo '${builtins.toJSON x}' | ${pkgs.jq}/bin/jq . > $out
    ";
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

  teleportYml =
    if cfg.configText != null then
      pkgs.writeText "teleport.yml" cfg.configText
    else generatedTeleportYml;

  cmdlineArgs = "-c ${teleportYml} --pid-file=/run/teleport.pid";

  telTypes.auth_service = types.submodule {
    options = {
      enabled = mkEnableOption {
        type = types.bool;
        default = false;
        description = "
          Enable the Teleport Cluster SSH daemon.
        ";
      };
      cluster_name = mkOption {
        type = types.str;
      };
      listen_addr = mkOption {
        type = types.str;
      };
      public_addr = mkOption {
        type = types.str;
      };
      tokens = mkOption {
        type = types.listOf types.str;
      };
    };
  };
  telTypes.ssh_service = types.submodule {
    options = {
      enabled = mkEnableOption {
        type = types.bool;
        default = false;
        description = "
          Enable the Teleport Cluster SSH daemon.
        ";
      };
    };
  };
  telTypes.proxy_service = types.submodule {
    options = {
      enabled = mkEnableOption {
        type = types.bool;
        default = false;
        description = "
          Enable the Teleport Cluster SSH daemon.
        ";
      };
      listen_addr = mkOption {
        type = types.str;
      };
      web_listen_addr = mkOption {
        type = types.str;
      };
      tunnel_listen_addr = mkOption {
        type = types.str;
      };
      https_key_file = mkOption {
        type = types.str;
      };
      https_cert_file = mkOption {
        type = types.str;
      };
    };
  };

in

{
  options = {
    services.teleport = {
      enable = mkEnableOption {
        type = types.bool;
        default = false;
        description = "
          Enable the Teleport Cluster SSH daemon.
        ";
      };
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/teleport/";
        description = "
          Directory to store Teleport Service data.
        ";
      };
      configText = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = "
          If non-null, this option defines the text that is written to
          teleport.yml.
        ";
      };
      nodename = mkOption {
        type = types.str;
        default = "";
        description = ''
          The name of your teleport node.
          This is what you `tsh ssh` to.
        '';
      };
      auth_token = mkOption {
        type = types.str;
        default = types.null;
        description = ''
          The auth token your teleport node authenticates with to your teleport auth nodes.
        '';
      };
      auth_servers = mkOption {
        type = types.listOf types.str;
        description = ''
          The set of Auth servers your Teleport node authenticates against.
        '';
      };
      auth_service = mkOption {
        type = telTypes.auth_service;
        default = {};
        description = ''
          Enable the Teleport SSH Auth service.
        '';
      };
      ssh_service = mkOption {
        type = telTypes.ssh_service;
        default = {};
        description = ''
          Enable the Teleport SSH service.
        '';
      };
      proxy_service = mkOption {
        type = telTypes.proxy_service;
        default = {};
        description = ''
          Enable the Teleport SSH Proxy service.
        '';
      };
    };
  };

    config = mkIf cfg.enable {
      systemd.services.teleport = {
        wantedBy = [ "multi-user.target" ];
        after    = [ "network.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.teleport}/bin/teleport start ${cmdlineArgs}";
          ExecReload = "/run/current-system/sw/bin/kill -HUP $MAINPID";
          PIDFile = "run/teleport.pid";
          Restart = "on-failure";
          WorkingDirectory = cfg.dataDir;
        };
      };
   };
}
