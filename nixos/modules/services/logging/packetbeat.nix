{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.packetbeat;
  format = pkgs.formats.yaml {};
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
        type = types.submodule {
          freeformType = format.type;
          options = {
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

            packetbeat = {
              interfaces = mkOption {
                type = format.type;
                description = ''
                  Configuration of what interfaces packetbeat should monitor and how. See
                  <link xlink:href='https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-interfaces.html'/>
                  for all available configuration options.
                '';
              };
              flows = mkOption {
                type = format.type;
                description = ''
                  Configuration of how packetbeat should handle flows. See
                  <link xlink:href='https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-flows.html'/>
                  for all available configuration options.
                '';
              };

              protocols = mkOption {
                type = types.listOf format.type;
                description = ''
                  Configuration of what protocols packetbeat should gather info about.
                  See <link xlink:href='https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-protocols.html'/>
                  for the configuration options available.
                '';
              };
            };
            output = mkOption {
              type = format.type;
              description = ''
                Configuration of where packetbeat should send the information its gathered.
                See <link xlink:href='https://www.elastic.co/guide/en/beats/packetbeat/current/configuring-output.html'/>
                for the configuration options available.
              '';
            };

            setup = mkOption {
              type = format.type;
              description = ''
                Configures where the kibana endpoint is for setting up dashboards and
                whether packetbeat should setup ILM and index templates in elasticsearch.
              '';
            };

            fields = mkOption {
              type = format.type;
              description = ''
                Extra fields that packetbeat should add to the top-level of the objects it
                sends to its output.
              '';
            };

            processors = mkOption {
              type = format.type;
              description = ''
                Configuration of what enrichment and/or filtering processors packetbeat
                should gather information from before sending it to the output.
                See <link xlink:href='https://www.elastic.co/guide/en/beats/packetbeat/current/filtering-and-enhancing-data.html'/>
                for the configuration options available.
              '';
            };
          };
        };
        default = {};
        description = ''
          Any other configuration options you want to add.
          See <link xlink:href='https://www.elastic.co/guide/en/beats/packetbeat/current/configuring-howto-packetbeat.html'/>
          for all the configuration options available for packetbeat.
        '';
        example = ''
          output = {
            elasticsearch = {
              hosts = [ "localhost:9200" ];
            };
          };
          setup = {
            template = {
              settings = {
                index.number_of_shards =  1;
              };
            };
            kibana = {
              host =  "localhost:5601";
            };
          };
          processors =  [
            '''
              if.contains.tags: forwarded
              then:
                - drop_fields:
                  fields: [host]
              else:
                - add_host_metadata: ~
            '''
            "add_cloud_metadata: ~"
            "add_docker_metadata: ~"
          ];
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.packetbeat.settings = {
      packetbeat = {
        interfaces.device = mkDefault "any";
        flows = {
          timeout = mkDefault "30s";
          period = mkDefault "10s";
        };
        protocols = mkBefore [
          {
            "type" = "icmp";
            enabled = true;
          }
          {
            "type" = "amqp";
            ports = [ 5672 ];
          }
          {
            "type" = "cassandra";
            ports = [ 9042 ];
          }
          {
            "type" = "dhcpv4";
            ports = [ 67 68 ];
          }
          {
            "type" = "dns";
            ports = [ 53 ];
          }
          {
            "type" = "http";
            ports = [ 80 8080 8000 5000 8002 ];
          }
          {
            "type" = "memcache";
            ports = [ 11211 ];
          }
          {
            "type" = "mysql";
            ports = [ 3306 3307 ];
          }
          {
            "type" = "pgsql";
            ports = [ 5432 ];
          }
          {
            "type" = "redis";
            ports = [ 6379 ];
          }
          {
            "type" = "thrift";
            ports = [ 9090 ];
          }
          {
            "type" = "mongodb";
            ports = [ 27017 ];
          }
          {
            "type" = "nfs";
            ports = [ 2049 ];
          }
          {
            "type" = "tls";
            ports = [ 443 993 995 5223 8443 8883 9243 ];
          }
        ];
      };
      output = {
        elasticsearch = {
          hosts = mkDefault [ "localhost:9200" ];
        };
      };
      setup = {
        template = {
          settings = {
            index.number_of_shards = mkDefault 1;
          };
        };
        kibana = {
          host = mkDefault "localhost:5601";
        };
      };
      processors = mkDefault [
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

    systemd.services.packetbeat = {
      description = "Packetbeat log shipper";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = mkMerge [
        {
          DynamicUser = "yes";
          AmbientCapabilities = [
            "CAP_NET_RAW"
            "CAP_NET_ADMIN"
          ];
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
