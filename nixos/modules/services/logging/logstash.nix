{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.logstash;
  atLeast54 = versionAtLeast (builtins.parseDrvName cfg.package.name).version "5.4";
  pluginPath = lib.concatStringsSep ":" cfg.plugins;
  havePluginPath = lib.length cfg.plugins > 0;
  ops = lib.optionalString;
  verbosityFlag =
    if atLeast54
    then "--log.level " + cfg.logLevel
    else {
      debug = "--debug";
      info  = "--verbose";
      warn  = ""; # intentionally empty
      error = "--quiet";
      fatal = "--silent";
    }."${cfg.logLevel}";

  pluginsPath =
    if atLeast54
    then "--path.plugins ${pluginPath}"
    else "--pluginpath ${pluginPath}";

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

  logstashSettingsDir = pkgs.runCommand "logstash-settings" {inherit logstashSettingsYml;} ''
    mkdir -p $out
    ln -s $logstashSettingsYml $out/logstash.yml
  '';
in

{
  ###### interface

  options = {

    services.logstash = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable logstash.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.logstash;
        defaultText = "pkgs.logstash";
        example = literalExample "pkgs.logstash";
        description = "Logstash package to use.";
      };

      plugins = mkOption {
        type = types.listOf types.path;
        default = [ ];
        example = literalExample "[ pkgs.logstash-contrib ]";
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

      enableWeb = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the logstash web interface.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = "Address on which to start webserver.";
      };

      port = mkOption {
        type = types.str;
        default = "9292";
        description = "Port on which to start webserver.";
      };

      inputConfig = mkOption {
        type = types.lines;
        default = ''generator { }'';
        description = "Logstash input configuration.";
        example = ''
          # Read from journal
          pipe {
            command => "''${pkgs.systemd}/bin/journalctl -f -o json"
            type => "syslog" codec => json {}
          }
        '';
      };

      filterConfig = mkOption {
        type = types.lines;
        default = "";
        description = "logstash filter configuration.";
        example = ''
          if [type] == "syslog" {
            # Keep only relevant systemd fields
            # http://www.freedesktop.org/software/systemd/man/systemd.journal-fields.html
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
        default = ''stdout { codec => rubydebug }'';
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


    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    assertions = [
      { assertion = atLeast54 -> !cfg.enableWeb;
        message = ''
          The logstash web interface is only available for versions older than 5.4.
          So either set services.logstash.enableWeb = false,
          or set services.logstash.package to an older logstash.
        '';
      }
    ];

    systemd.services.logstash = with pkgs; {
      description = "Logstash Daemon";
      wantedBy = [ "multi-user.target" ];
      environment = { JAVA_HOME = jre; };
      path = [ pkgs.bash ];
      serviceConfig = {
        ExecStartPre = ''${pkgs.coreutils}/bin/mkdir -p "${cfg.dataDir}" ; ${pkgs.coreutils}/bin/chmod 700 "${cfg.dataDir}"'';
        ExecStart = concatStringsSep " " (filter (s: stringLength s != 0) [
          "${cfg.package}/bin/logstash"
          (ops (!atLeast54) "agent")
          "-w ${toString cfg.filterWorkers}"
          (ops havePluginPath pluginsPath)
          "${verbosityFlag}"
          "-f ${logstashConf}"
          (ops atLeast54 "--path.settings ${logstashSettingsDir}")
          (ops atLeast54 "--path.data ${cfg.dataDir}")
          (ops cfg.enableWeb "-- web -a ${cfg.listenAddress} -p ${cfg.port}")
        ]);
      };
    };
  };
}
