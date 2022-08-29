{ lib, pkgs, config, ... }:

with lib;

let
  pkg = pkgs.tox-node;
  cfg = config.services.tox-node;
  homeDir = "/var/lib/tox-node";

  configFile = let
    src = "${pkg.src}/dpkg/config.yml";
    confJSON = pkgs.writeText "config.json" (
      builtins.toJSON {
        log-type = cfg.logType;
        keys-file = cfg.keysFile;
        udp-address = cfg.udpAddress;
        tcp-addresses = cfg.tcpAddresses;
        tcp-connections-limit = cfg.tcpConnectionLimit;
        lan-discovery = cfg.lanDiscovery;
        threads = cfg.threads;
        motd = cfg.motd;
      }
    );
  in with pkgs; runCommand "config.yml" {} ''
    ${remarshal}/bin/remarshal -if yaml -of json ${src} -o src.json
    ${jq}/bin/jq -s '(.[0] | with_entries( select(.key == "bootstrap-nodes"))) * .[1]' src.json ${confJSON} > $out
  '';

in {
  options.services.tox-node = {
    enable = mkEnableOption "Tox Node service";

    logType = mkOption {
      type = types.enum [ "Stderr" "Stdout" "Syslog" "None" ];
      default = "Stderr";
      description = lib.mdDoc "Logging implementation.";
    };
    keysFile = mkOption {
      type = types.str;
      default = "${homeDir}/keys";
      description = lib.mdDoc "Path to the file where DHT keys are stored.";
    };
    udpAddress = mkOption {
      type = types.str;
      default = "0.0.0.0:33445";
      description = lib.mdDoc "UDP address to run DHT node.";
    };
    tcpAddresses = mkOption {
      type = types.listOf types.str;
      default = [ "0.0.0.0:33445" ];
      description = lib.mdDoc "TCP addresses to run TCP relay.";
    };
    tcpConnectionLimit = mkOption {
      type = types.int;
      default = 8192;
      description = lib.mdDoc "Maximum number of active TCP connections relay can hold";
    };
    lanDiscovery = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc "Enable local network discovery.";
    };
    threads = mkOption {
      type = types.int;
      default = 1;
      description = lib.mdDoc "Number of threads for execution";
    };
    motd = mkOption {
      type = types.str;
      default = "Hi from tox-rs! I'm up {{uptime}}. TCP: incoming {{tcp_packets_in}}, outgoing {{tcp_packets_out}}, UDP: incoming {{udp_packets_in}}, outgoing {{udp_packets_out}}";
      description = lib.mdDoc "Message of the day";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.tox-node = {
      description = "Tox Node";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkg}/bin/tox-node config ${configFile}";
        StateDirectory = "tox-node";
        DynamicUser = true;
        Restart = "always";
      };
    };
  };
}
