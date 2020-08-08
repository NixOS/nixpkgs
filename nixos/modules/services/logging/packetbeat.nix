{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.packetbeat;

  packetbeatYml = pkgs.writeText "packetbeat.yml" ''
    name: ${cfg.name}
    tags: ${builtins.toJSON cfg.tags}

    ${cfg.configFlows}
    ${cfg.configProtocols}
    ${cfg.extraConfig}
  '';

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
        default = /var/lib/packetbeat;
        description = ''
          Directory to store packetbeat's own logs and other data.
          This directory will be created automatically using systemd's 
          StateDirectory mechanism.
        '';
      };

      configFlows = mkOption {
        type = types.lines;
        default = ''
          packebeat.flows:
            timeout: 30s
            period: 10s
        '';
        description = ''
          Configuration of how packetbeat should handle flows. See
          <link xlink:href='https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-flows.html'/>
          for all available configuration options.
        '';
      };

      configProtocols = mkOption {
        type = types.lines;
        default = ''
          packetbeat.protocols:
          - type: icmp
            enabled: true
          - type: amqp
            ports: [5672]
          - type: cassandra
            ports: [9042]
          - type: dhcpv4
            ports: [67, 68]
          - type: dns
            ports: [53]
          - type: http
            ports: [80, 8080, 8000, 5000, 8002]
          - type: memcache
            ports: [11211]
          - type: mysql
            ports: [3306,3307]
          - type: pgsql
            ports: [5432]
          - type: redis
            ports: [6379]
          - type: thrift
            ports: [9090]
          - type: mongodb
            ports: [27017]
          - type: nfs
            ports: [2049]
          - type: tls
            ports:
              - 443   # HTTPS
              - 993   # IMAPS
              - 995   # POP3S
              - 5223  # XMPP over SSL
              - 8443
              - 8883  # Secure MQTT
              - 9243  # Elasticsearch

        '';
        description = ''
          Configuration of what protocols packetbeat should gather info about.
          See <link xlink:href='https://www.elastic.co/guide/en/beats/packetbeat/current/configuration-protocols.html'/>
          for the configuration options available.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = ''
          packetbeat.interfaces.device: any

          setup.template.settings:
            index.number_of_shards: 1

          setup.kibana:
            host: "localhost:5601"

          output.elasticsearch:
            hosts: ["localhost:9200"]

          processors:
            - # Add forwarded to tags when processing data from a network tap or mirror.
              if.contains.tags: forwarded
              then:
                - drop_fields:
                    fields: [host]
              else:
                - add_host_metadata: ~
            - add_cloud_metadata: ~
            - add_docker_metadata: ~
        '';
        description = "Any other configuration options you want to add";
      };

    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.configProtocols != "" || cfg.configFlows != "";
        message =
          "The options services.packetbeat.configProtocols and/or services.packetbeat.configFlows should" +
          " be set or else packetbeat won't do anything useful and error out.";
      }
    ];

    systemd.services.packetbeat = {
      description = "Packetbeat log shipper";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p ${cfg.stateDir}/data
        mkdir -p ${cfg.stateDir}/logs
      '';
      serviceConfig = {
        StateDirectory = cfg.stateDir;
        ExecStart = ''
          ${cfg.package}/bin/packetbeat \
            -c ${packetbeatYml} \
            -path.data /var/lib/${cfg.stateDir}/data \
            -path.logs /var/lib/${cfg.stateDir}/logs'';
        Restart = "always";
      };
    };
  };
}
