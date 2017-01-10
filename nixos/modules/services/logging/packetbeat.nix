{ config, lib, pkgs, ... }:

with lib;
let
  inherit (pkgs) packetbeat;
  cfg = config.services.packetbeat;
  confFile = pkgs.writeText "packetbeat.yml" ''
    ${cfg.configuration}
  '';
in
{
  ###### interface
  options = {
    services.packetbeat = {
      enable = mkEnableOption "packetbeat";
      configuration = mkOption {
        type = types.str;
        default = ''
          # You can find the full configuration reference here:
          # https://www.elastic.co/guide/en/beats/packetbeat/index.html
          packetbeat.interfaces.device: any
          packetbeat.flows:
            timeout: 30s
            period: 10s
          packetbeat.protocols.icmp:
            enabled: true
          packetbeat.protocols.dns:
            ports: [53]
            include_authorities: true
            include_additionals: true
          packetbeat.protocols.http:
            ports: [80, 8080, 8000, 5000, 8002]
          fields:
            serviceConfig: IDidNotConfigureThePacketbeatService
          output.logstash:
            hosts: ["localhost:5044"]
        '';
        description = "Verbatim packetbeat configuration YAML file";
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    systemd.services.packetbeat = {
      description = "Packetbeat service";
      after = [ "network.target" "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${packetbeat}/bin/packetbeat -c ${confFile} -E path.home /var/lib/packetbeat/";
      preStart = ''
        mkdir -p /var/lib/packetbeat
        echo Testing validity of packetbeat config file
        ${packetbeat}/bin/packetbeat -configtest -c ${confFile} -E path.home /var/lib/packetbeat/
      '';
    };
  };

}
