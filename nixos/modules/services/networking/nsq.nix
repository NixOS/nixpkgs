{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.nsq;

  # Convert a Nix attrset to TOML by way of JSON:
  toTOML = name: attrs:
    pkgs.runCommand "${name}.toml" {
      buildInputs = [ pkgs.remarshal ];
    } ''
      remarshal -if json -of toml \
        < ${pkgs.writeText "${name}.json" (builtins.toJSON attrs)} \
        > $out
    '';

  # Configuration for nsqd as a Nix attrset:
  nsqdConfig = recursiveUpdate {
    mem_queue_size = cfg.nsqd.queueSize;
    data_path = "${cfg.dataDir}/nsqd";
    tcp_address = "${cfg.nsqd.tcpAddress}:${toString cfg.nsqd.tcpPort}";
    http_address = "${cfg.nsqd.httpAddress}:${toString cfg.nsqd.httpPort}";
    https_address = "${cfg.nsqd.httpsAddress}:${toString cfg.nsqd.httpsPort}";
  } cfg.nsqd.extraConfig;

  # Configuration for nsqd written into the Nix store as TOML:
  nsqdConfigFile = toTOML "nsqd" nsqdConfig;

  # Configuration for nsqlookupd as a Nix attrset:
  nsqlookupdConfig = recursiveUpdate {
    tcp_address = "${cfg.nsqlookupd.tcpAddress}:${toString cfg.nsqlookupd.tcpPort}";
    http_address = "${cfg.nsqlookupd.httpAddress}:${toString cfg.nsqlookupd.httpPort}";
  } cfg.nsqlookupd.extraConfig;

  # Configuration for nsqlookupd written into the Nix store as TOML:
  nsqlookupdConfigFile = toTOML "nsqlookupd" nsqlookupdConfig;

  # Configuration for nsqadmin as a Nix attrset:
  nsqadminConfig = recursiveUpdate {
    http_address = "${cfg.nsqadmin.httpAddress}:${toString cfg.nsqadmin.httpPort}";
    nsqlookupd_http_addresses = cfg.nsqadmin.lookupdHttpAddresses;
    nsqd_http_addresses = cfg.nsqadmin.nsqdHttpAddresses;
  } cfg.nsqadmin.extraConfig;

  # Configuration for nsqadmin written into the Nix store as TOML:
  nsqadminConfigFile = toTOML "nsqadmin" nsqadminConfig;

  # Generate a systemd service:
  mkService = name: configFile: {
    description = "${name} NSQ daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.User = cfg.user;
    serviceConfig.Group = cfg.group;
    serviceConfig.PermissionsStartOnly = true;
    path = [ cfg.package ];

    preStart = ''
      mkdir -p ${cfg.dataDir}/${name}
      chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}/${name}
      chmod -R u=rwX,g=rX,o= ${cfg.dataDir}/${name}
    '';

    script = "${name} -config ${configFile}";
  };

in
{
  #### Interface
  options.services.nsq = {
    nsqd = {
      enable = mkEnableOption "The NSQ message daemon.";

      queueSize = mkOption {
        type = types.ints.positive;
        default = 10000;
        example = 0;
        description = "Number of messages to keep in memory.";
      };

      tcpAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        example = "127.0.0.1";
        description = "Address to listen on for TCP clients.";
      };

      tcpPort = mkOption {
        type = types.ints.positive;
        default = 4150;
        description = "Port number to listen on for TCP clients.";
      };

      httpAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        example = "127.0.0.1";
        description = "Address to listen on for HTTP clients.";
      };

      httpPort = mkOption {
        type = types.ints.positive;
        default = 4151;
        description = "Port number to listen on for HTTP clients.";
      };

      httpsAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        example = "127.0.0.1";
        description = "Address to listen on for HTTPS clients.";
      };

      httpsPort = mkOption {
        type = types.ints.positive;
        default = 4152;
        description = "Port number to listen on for HTTPS clients.";
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = { };
        example = { sync_every = 2500; };
        description = "Extra options to write into the configuration file.";
      };
    };

    nsqlookupd = {
      enable = mkEnableOption "The NSQ topology information daemon.";

      tcpAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        example = "127.0.0.1";
        description = "Address to listen on for TCP clients.";
      };

      tcpPort = mkOption {
        type = types.ints.positive;
        default = 4160;
        description = "Port number to listen on for TCP clients.";
      };

      httpAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        example = "127.0.0.1";
        description = "Address to listen on for HTTP clients.";
      };

      httpPort = mkOption {
        type = types.ints.positive;
        default = 4161;
        description = "Port number to listen on for HTTP clients.";
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = { };
        example = { inactive_producer_timeout = "300s"; };
        description = "Extra options to write into the configuration file.";
      };
    };

    nsqadmin = {
      enable = mkEnableOption "The NSQ Web UI.";

      httpAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        example = "127.0.0.1";
        description = "Address to listen on for HTTP clients.";
      };

      httpPort = mkOption {
        type = types.ints.positive;
        default = 4171;
        description = "Port number to listen on for HTTP clients.";
      };

      lookupdHttpAddresses = mkOption {
        type = types.listOf types.str;
        default = [ "127.0.0.1:4161" ];
        description = ''
          List of addresses (with port numbers) where nsqlookupd
          instances can be reached.
        '';
      };

      nsqdHttpAddresses = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "127.0.0.1:4151" ];
        description = ''
          List of addresses (with port numbers) where nsqd instances
          can be reached.  This is optional if you have set
          <option>lookupdHttpAddresses</option>.
        '';
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = { };
        example = { statsd_interval = "60s"; };
        description = "Extra options to write into the configuration file.";
      };
    };

    user = mkOption {
      type = types.str;
      default = "nsq";
      description = "User under which the NSQ daemons run.";
    };

    group = mkOption {
      type = types.str;
      default = "nsq";
      description = "Group under which the NSQ daemons run.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/nsq";
      description = "Base directory where NSQ can persist files.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open firewall ports for enabled NSQ services.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nsq;
      description = "The nsq package to use.";
    };
  };

  #### Implementation
  config = mkMerge [

    # Users and groups:
    (mkIf (cfg.nsqd.enable || cfg.nsqlookupd.enable || cfg.nsqadmin.enable) {
      users.users = mkIf (cfg.user == "nsq") {
        nsq = {
          group = cfg.group;
          home = cfg.dataDir;
          uid = config.ids.uids.nsq;
          description = "NSQ daemon user";
        };
      };

      users.groups = mkIf (cfg.group == "nsq") {
        nsq.gid = config.ids.gids.nsq;
      };
    })

    # The nsqd service:
    (mkIf cfg.nsqd.enable {
      systemd.services.nsqd = mkService "nsqd" nsqdConfigFile;

      networking.firewall.allowedTCPPorts =
        optionals cfg.openFirewall [ cfg.nsqd.tcpPort
                                     cfg.nsqd.httpPort
                                     cfg.nsqd.httpsPort
                                   ];
    })

    # The nsqlookupd service:
    (mkIf cfg.nsqlookupd.enable {
      systemd.services.nsqlookupd = mkService "nsqlookupd" nsqlookupdConfigFile;

      networking.firewall.allowedTCPPorts =
        optionals cfg.openFirewall [ cfg.nsqlookupd.tcpPort
                                     cfg.nsqlookupd.httpPort
                                   ];
    })

    # The nsqadmin service:
    (mkIf cfg.nsqadmin.enable {
      assertions = [
        { assertion = (length cfg.nsqadmin.lookupdHttpAddresses > 0) ||
                      (length cfg.nsqadmin.nsqdHttpAddresses > 0);
          message = ''
            nsqadmin requires that you either set lookupdHttpAddresses
            or nsqdHttpAddresses.
          '';
        }
      ];

      systemd.services.nsqadmin = mkService "nsqadmin" nsqadminConfigFile;

      networking.firewall.allowedTCPPorts =
        optional cfg.openFirewall cfg.nsqadmin.httpPort;
    })
  ];
}
