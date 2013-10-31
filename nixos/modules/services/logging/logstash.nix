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
        example = ''
          # Read from journal
          pipe {
            command => "${pkgs.systemd}/bin/journalctl -f -o json"
            type => "syslog" codec => json {}
          }
        '';
      };

      filterConfig = mkOption {
        default = ''noop {}'';
        description = "logstash filter configuration";
        example = ''
          if [type] == "syslog" {
            # Keep only relevant systemd fields
            # http://www.freedesktop.org/software/systemd/man/systemd.journal-fields.html
            prune {
              whitelist_names => [
                "type", "@timestamp", "@version",
                "MESSAGE", "PRIORITY", "SYSLOG_FACILITY",
              ]
            }
          }
        '';
      };

      outputConfig = mkOption {
        default = ''stdout { debug => true debug_format => "json"}'';
        description = "Logstash output configuration";
        example = ''
          redis { host => "localhost" data_type => "list" key => "logstash" codec => json }
          elasticsearch { embedded => true }
        '';
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
