{ config, lib, pkgs, ... }:
with lib;

let
  inherit (builtins) toJSON toFile;
  inherit (lib.attrsets) recursiveUpdate;
  inherit (pkgs) redpanda-console;

  cfg = config.services.redpanda-console;
  brokers = concatStringsSep ","
    (map (x: x.address + ":" + toString x.port) cfg.kafkaBrokers);

  defaultConfig = {
    kafka.brokers = brokers;
    server.listenPort = cfg.port;
  };

  consoleConfig = recursiveUpdate defaultConfig cfg.settings;
  consoleYaml = toFile "redpanda-console.yaml" ( toJSON consoleConfig );

in
{
  options.services.redpanda-console = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = "Enable Redpanda console";
    };

    kafkaBrokers = mkOption {
      description = "Kafka brokers to connect to";
      default = [ ];
      type = listOf (submodule {
        options = {
          address = mkOption {
            type = str;
          };
          port = mkOption {
            type = port;
          };
        };
      });
    };

    port = mkOption {
      type = port;
      default = 8080;
      description = "Port to listen on";
    };

    openPorts = mkOption {
      type = bool;
      default = true;
      description = "Open port in firewall";
    };

    settings = mkOption {
      type = attrsOf anything;
      default = { };
      description = ''Redpanda console configuration properties

      Reference: https://docs.redpanda.com/docs/reference/console/config/
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = consoleConfig.kafka.brokers != "";
        message = "No Kafka brokers specified";
      }
    ];

    networking.firewall.allowedTCPPorts = mkIf cfg.openPorts [ cfg.port ];

    systemd.services.redpanda-console = {
      description = "Redpanda Console, UI for Kafka/Redpanda.";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      documentation = [ "https://docs.redpanda.com" ];
      serviceConfig = {
        ExecStart = "${redpandaconsole}/bin/redpanda-console -config.filepath ${consoleYaml}";
        Restart="on-failure";
        TimeoutStartSec = 120;
        RestartSec = 5;
      };
    };
  };
}
