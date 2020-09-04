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
          options = {
            freeformType = format.type;
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
                type = with types; attrsOf (oneOf [ bool str ]);
                description = ''
                  Configuration of what interfaces packetbeat should monitor and how. See
                  <link xlink:href='https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-interfaces.html'/>
                  for all available configuration options.
                '';
              };
              flows = mkOption {
                type = with types; attrsOf (oneOf [ bool str ]);
                description = ''
                  Configuration of how packetbeat should handle flows. See
                  <link xlink:href='https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-flows.html'/>
                  for all available configuration options.
                '';
              };

              protocols = mkOption {
                type = with types; attrsOf (oneOf [ bool (listOf port) (listOf str) ]);
                description = ''
                  Configuration of what protocols packetbeat should gather info about.
                  See <link xlink:href='https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-protocols.html'/>
                  for the configuration options available.
                '';
              };
            };
            output = mkOption {
              type = with types; attrsOf (oneOf [ bool str (attrsOf str) (linesOf str) ]);
              description = ''
                Configuration of where packetbeat should send the information its gathered.
                See <link xlink:href='https://www.elastic.co/guide/en/beats/packetbeat/current/configuring-output.html'/>
                for the configuration options available.
              '';
            };

            setup = mkOption {
              type = with types; attrsOf (oneOf [ bool str (attrsOf str) ]);
              description = ''
                Configures where the kibana endpoint is for setting up dashboards and
                whether packetbeat should setup ILM and index templates in elasticsearch.
              '';
            };

            fields = mkOption {
              type = with types; attrsOf str;
              description = ''
                Extra fields that packetbeat should add to the top-level of the objects it
                sends to its output.
              '';
            };

            processors = mkOption {
              type = with types; listOf (oneOf [ str (listOf str) (attrsOf str) ]);
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
        protocols = mapAttrs (name: mkDefault) {
          icmp = {
            enabled = true;
          };
          amqp = {
            ports = [ 5672 ];
          };
          cassandra = {
            ports = [ 9042 ];
          };
          dhcpv4 = {
            ports = [ 67 68 ];
          };
          dns = {
            ports = [ 53 ];
          };
          http = {
            ports = [ 80 8080 8000 5000 8002 ];
          };
          memcache = {
            ports = [ 11211 ];
          };
          mysql = {
            ports = [ 3306 3307 ];
          };
          pgsql = {
            ports = [ 5432 ];
          };
          redis = {
            ports = [ 6379 ];
          };
          thrift = {
            ports = [ 9090 ];
          };
          mongodb = {
            ports = [ 27017 ];
          };
          nfs = {
            ports = [ 2049 ];
          };
          tls = {
            ports = [ 443 993 995 5223 8443 8883 9243 ];
          };
        };

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
