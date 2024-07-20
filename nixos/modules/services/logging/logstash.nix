{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.logstash;
  ops = lib.optionalString;
  verbosityFlag = "--log.level " + cfg.logLevel;

  logstashConf = pkgs.writeText "logstash.conf" ''
    input {
      ${cfg.inputConfig}
    }

    filter {
      ${cfg.filterConfig}
    }

    output {
      ${cfg.outputConfig}
    }
  '';

  logstashSettingsYml = pkgs.writeText "logstash.yml" cfg.extraSettings;

  logstashJvmOptionsFile = pkgs.writeText "jvm.options" cfg.extraJvmOptions;

  logstashSettingsDir = pkgs.runCommand "logstash-settings" {
      inherit logstashJvmOptionsFile;
      inherit logstashSettingsYml;
      preferLocalBuild = true;
    } ''
    mkdir -p $out
    ln -s $logstashSettingsYml $out/logstash.yml
    ln -s $logstashJvmOptionsFile $out/jvm.options
  '';
in

{
  imports = [
    (mkRenamedOptionModule [ "services" "logstash" "address" ] [ "services" "logstash" "listenAddress" ])
    (mkRemovedOptionModule [ "services" "logstash" "enableWeb" ] "The web interface was removed from logstash")
  ];

  ###### interface

  options = {

    services.logstash = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable logstash.";
      };

      package = mkPackageOption pkgs "logstash" { };

      plugins = mkOption {
        type = types.listOf types.path;
        default = [ ];
        example = literalExpression "[ pkgs.logstash-contrib ]";
        description = "The paths to find other logstash plugins in.";
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/logstash";
        description = ''
          A path to directory writable by logstash that it uses to store data.
          Plugins will also have access to this path.
        '';
      };

      logLevel = mkOption {
        type = types.enum [ "debug" "info" "warn" "error" "fatal" ];
        default = "warn";
        description = "Logging verbosity level.";
      };

      filterWorkers = mkOption {
        type = types.int;
        default = 1;
        description = "The quantity of filter workers to run.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Address on which to start webserver.";
      };

      port = mkOption {
        type = types.str;
        default = "9292";
        description = "Port on which to start webserver.";
      };

      inputConfig = mkOption {
        type = types.lines;
        default = "generator { }";
        description = "Logstash input configuration.";
        example = literalExpression ''
          '''
            # Read from journal
            pipe {
              command => "''${config.systemd.package}/bin/journalctl -f -o json"
              type => "syslog" codec => json {}
            }
          '''
        '';
      };

      filterConfig = mkOption {
        type = types.lines;
        default = "";
        description = "logstash filter configuration.";
        example = ''
          if [type] == "syslog" {
            # Keep only relevant systemd fields
            # https://www.freedesktop.org/software/systemd/man/systemd.journal-fields.html
            prune {
              whitelist_names => [
                "type", "@timestamp", "@version",
                "MESSAGE", "PRIORITY", "SYSLOG_FACILITY"
              ]
            }
          }
        '';
      };

      outputConfig = mkOption {
        type = types.lines;
        default = "stdout { codec => rubydebug }";
        description = "Logstash output configuration.";
        example = ''
          redis { host => ["localhost"] data_type => "list" key => "logstash" codec => json }
          elasticsearch { }
        '';
      };

      extraSettings = mkOption {
        type = types.lines;
        default = "";
        description = "Extra Logstash settings in YAML format.";
        example = ''
          pipeline:
            batch:
              size: 125
              delay: 5
        '';
      };

      extraJvmOptions = mkOption {
        type = types.lines;
        default = "";
        description = "Extra JVM options, one per line (jvm.options format).";
        example = ''
          -Xms2g
          -Xmx2g
        '';
      };

    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.logstash = {
      description = "Logstash Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.bash ];
      serviceConfig = {
        ExecStartPre = ''${pkgs.coreutils}/bin/mkdir -p "${cfg.dataDir}" ; ${pkgs.coreutils}/bin/chmod 700 "${cfg.dataDir}"'';
        ExecStart = concatStringsSep " " (filter (s: stringLength s != 0) [
          "${cfg.package}/bin/logstash"
          "-w ${toString cfg.filterWorkers}"
          (concatMapStringsSep " " (x: "--path.plugins ${x}") cfg.plugins)
          "${verbosityFlag}"
          "-f ${logstashConf}"
          "--path.settings ${logstashSettingsDir}"
          "--path.data ${cfg.dataDir}"
        ]);
      };
    };
  };
}
