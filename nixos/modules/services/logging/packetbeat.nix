{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.packetbeat;
  format = pkgs.formats.yaml;
in
{
  options = {

    services.packetbeat = {
      enable = mkEnableOption "packetbeat";

      package = mkOption {
        type = types.package;
        default = pkgs.packetbeat;
        defaultText = "pkgs.packetbeat";
        example = literalExample "pkgs.packetbeat7";
        description = ''
          The packetbeat package to use
        '';
      };

      name = mkOption {
        type = types.str;
        default = "packetbeat";
        description = "Name of the beat";
      };

      tags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Tags to place on the shipped log messages";
      };

      stateDir = mkOption {
        type = types.path;
        default = "/var/lib/packetbeat";
        description = ''
          Directory to store packetbeat's data. If left as the default value
          this directory will automatically be created before packetbeat starts, otherwise
          the sysadmin is responsible for ensuring the directory exists with appropriate ownership
          and permissions.
        '';
      };

      settings = mkOption {
        type = format.type;
        default = {
          packetbeat.interfaces.device = "any";
          setup = {
            template = {
              settings = {
                index.number_of_shards = 1;
              };
            };
            kibana = {
              host = "localhost:5601";
            };
          };
          output = {
            elasticsearch = {
              hosts = [ "localhost:9200" ];
            };
          };
          processors = [
            ''
              if.contains.tags: forwarded
              then:
                - drop_fields:
                  fields: [host]
              else:
                - add_host_metadata: ~
            ''
            "add_cloud_metadata: ~"
            "add_docker_metadata: ~"
          ];
        };
        description = ''
          Any other configuration options you want to add.
        '';
        # example = move the example which was in extraConfig here
      };

      flows = mkOption {
        type = with types; attrsOf (either (bool str (listOf str)));
        default = {
          timeout = "30s";
          period = "10s";
        };
        description = ''
          Configuration of how packetbeat should handle flows. See
          <link xlink:href='https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-flows.html'/>
          for all available configuration options.
          Note: This will be put under the packetbeat.flows directive,
          so no need to add it in this set.
        '';
      };

      protocols = mkOption {
        type = with types; attrsOf (either (bool (listOf port)));
        default = {
          icmp = true;
          amqp = [ 5672 ];
          cassandra = [ 9042 ];
          dhcpv4 = [ 67 68 ];
          dns = [ 53 ];
          http = [ 80 8080 8000 5000 8002 ];
          memcache = [ 11211 ];
          mysql = [ 3306 3307 ];
          pgsql = [ 5432 ];
          redis = [ 6379 ];
          thrift = [ 9090 ];
          mongodb = [ 27017 ];
          nfs = [ 2049 ];
          tls = [ 443 993 995 5223 8443 8883 9243 ];
        };
        description = ''
          Configuration of what protocols packetbeat should gather info about.
          See <link xlink:href='https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-protocols.html'/>
          for the configuration options available.
          Note: This will be put under the packetbeat.protocols directive,
          so no need to add it in this set.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    services.packetbeat.settings = {
      name = cfg.name;
      tags = cfg.tags;
      packetbeat = {
        flows = cfg.flows;
        protocols = cfg.protocols;
      };
    };

    systemd.services.packetbeat = {
      description = "Packetbeat log shipper";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = mkMerge [
        {
          ExecStart = ''
            ${cfg.package}/bin/packetbeat \
              -c ${format.generate "packetbeat.yml" cfg.settings} \
              -path.data ${cfg.stateDir} \
              -e
          '';
          Restart = "always";
          LogsDirectory = "packetbeat";
        }
        (mkIf (cfg.stateDir == "/var/lib/packetbeat") {
          StateDirectory = "packetbeat";
        })
      ];
    };
  };
}
