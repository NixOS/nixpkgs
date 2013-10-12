{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.logstash;

in

{
  ###### interface

  options = {
    services.logstash = {
      enable = mkOption {
        default = false;
        description = "Enable logstash";
      };

      inputConfig = mkOption {
        default = ''stdin { type => "example" }'';
        description = "Logstash input configuration";
      };

      filterConfig = mkOption {
        default = ''noop {}'';
        description = "logstash filter configuration";
      };

      outputConfig = mkOption {
        default = ''stdout { debug => true debug_format => "json"}'';
        description = "Logstash output configuration";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.logstash = with pkgs; {
      description = "Logstash daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${jre}/bin/java -jar ${logstash} agent -f ${writeText "logstash.conf" ''
          input {
            ${cfg.inputConfig}
          }

          filter {
            ${cfg.filterConfig}
          }

          output {
            ${cfg.outputConfig}
          }
        ''}";
      };
    };
  };
}
