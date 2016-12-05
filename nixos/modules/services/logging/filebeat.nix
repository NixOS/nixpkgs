{ config, lib, pkgs, ... }:

with lib;
let
  inherit (pkgs) filebeat;
  cfg = config.services.filebeat;
  confFile = pkgs.writeText "filebeat.yml" ''
    ${cfg.configuration}
  '';
in
{
  ###### interface
  options = {
    services.filebeat = {
      enable = mkEnableOption "filebeat";
      configuration = mkOption {
        type = types.str;
        default = ''
          # You can find the full configuration reference here:
          # https://www.elastic.co/guide/en/beats/filebeat/index.html
          filebeat.prospectors:
          - input_type: log
            paths:
              - /var/log/*.log
          output.logstash:
            hosts: ["localhost:5044"]
        '';
        description = "Verbatim filebeat configuration YAML file";
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    systemd.services.filebeat = {
      description = "filebeat service";
      after = [ "network.target" "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${filebeat}/bin/filebeat -c ${confFile} -E path.home /var/lib/filebeat/";
      preStart = ''
        mkdir -p /var/lib/filebeat
        echo Testing validity of filebeat config file
        ${filebeat}/bin/filebeat -configtest -c ${confFile} -E path.home /var/lib/filebeat/
      '';
    };
  };

}
