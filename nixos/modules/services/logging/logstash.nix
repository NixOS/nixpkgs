{
  config,
  lib,
  pkgs,
  ...
}:
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

  logstashSettingsDir =
    pkgs.runCommand "logstash-settings"
      {
        inherit logstashJvmOptionsFile;
        inherit logstashSettingsYml;

      }
      ''
        mkdir -p $out
        ln -s $logstashSettingsYml $out/logstash.yml
        ln -s $logstashJvmOptionsFile $out/jvm.options
      '';
in

{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "logstash" "address" ]
      [ "services" "logstash" "listenAddress" ]
    )
    (lib.mkRemovedOptionModule [
      "services"
      "logstash"
      "enableWeb"
    ] "The web interface was removed from logstash")
  ];

  ###### interface

  options = {

    services.logstash = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable logstash.";
      };

      package = lib.mkPackageOption pkgs "logstash" { };

      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        example = lib.literalExpression "[ pkgs.logstash-contrib ]";
        description = "The paths to find other logstash plugins in.";
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/logstash";
        description = ''
          A path to directory writable by logstash that it uses to store data.
          Plugins will also have access to this path.
        '';
      };

      logLevel = lib.mkOption {
        type = lib.types.enum [
          "debug"
          "info"
          "warn"
          "error"
          "fatal"
        ];
        default = "warn";
        description = "Logging verbosity level.";
      };

      filterWorkers = lib.mkOption {
        type = lib.types.int;
        default = 1;
        description = "The quantity of filter workers to run.";
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Address on which to start webserver.";
      };

      port = lib.mkOption {
        type = lib.types.str;
        default = "9292";
        description = "Port on which to start webserver.";
      };

      inputConfig = lib.mkOption {
        type = lib.types.lines;
        default = "generator { }";
        description = "Logstash input configuration.";
        example = lib.literalExpression ''
          '''
            # Read from journal
            pipe {
              command => "''${config.systemd.package}/bin/journalctl -f -o json"
              type => "syslog" codec => json {}
            }
          '''
        '';
      };

      filterConfig = lib.mkOption {
        type = lib.types.lines;
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

      outputConfig = lib.mkOption {
        type = lib.types.lines;
        default = "stdout { codec => rubydebug }";
        description = "Logstash output configuration.";
        example = ''
          redis { host => ["localhost"] data_type => "list" key => "logstash" codec => json }
          elasticsearch { }
        '';
      };

      extraSettings = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Extra Logstash settings in YAML format.";
        example = ''
          pipeline:
            batch:
              size: 125
              delay: 5
        '';
      };

      extraJvmOptions = lib.mkOption {
        type = lib.types.lines;
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

  config = lib.mkIf cfg.enable {
    systemd.services.logstash = {
      description = "Logstash Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.bash ];
      serviceConfig = {
        ExecStartPre = ''${pkgs.coreutils}/bin/mkdir -p "${cfg.dataDir}" ; ${pkgs.coreutils}/bin/chmod 700 "${cfg.dataDir}"'';
        ExecStart = lib.concatStringsSep " " (
          lib.filter (s: lib.stringLength s != 0) [
            "${cfg.package}/bin/logstash"
            "-w ${toString cfg.filterWorkers}"
            (lib.concatMapStringsSep " " (x: "--path.plugins ${x}") cfg.plugins)
            "${verbosityFlag}"
            "-f ${logstashConf}"
            "--path.settings ${logstashSettingsDir}"
            "--path.data ${cfg.dataDir}"
          ]
        );
      };
    };
  };
}
