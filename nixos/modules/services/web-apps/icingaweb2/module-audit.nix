{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.icingaweb2.modules.audit;

  configIni = ''
    [log]
    type = "${cfg.log}"
    ${optionalString (cfg.log == "syslog") ''
      ident = "${cfg.syslogApplication}"
      facility = "${cfg.syslogFacility}"
    ''}
    ${optionalString (cfg.log == "file") ''path = "${cfg.logFile}"''}

    [stream]
    format = "${if cfg.logJSON then "json" else "none"}"
    path = "${cfg.logFileJSON}"
  '';

in {
  options.services.icingaweb2.modules.audit = with types; {
    enable = mkEnableOption "the icingaweb2 audit module";

    mutableAuditConfig = mkOption {
      type = bool;
      default = false;
      description = "Make config.ini of the audit module mutable (e.g. via the web interface).";
    };

    log = mkOption {
      type = enum [ "none" "syslog" "file" ];
      default = "none";
      description = "Target of the human-readable log.";
    };

    syslogApplication = mkOption {
      type = str;
      default = "icingaweb2-audit";
      description = "Application name to log under";
    };

    syslogFacility = mkOption {
      type = enum [ "auth" "authpriv" "user" "local0" "local1" "local2" "local3" "local4" "local5" "local6" "local7" ];
      default = "auth";
      description = "Syslog facility to log to";
    };

    logFile = mkOption {
      type = str;
      default = "/var/log/icingaweb2/audit.log";
      description = "Full path to the standard log file";
    };

    logJSON = mkOption {
      type = bool;
      default = false;
      description = "Also log machine-parsable JSON objects";
    };

    logFileJSON = mkOption {
      type = str;
      default = "/var/log/icingaweb2/audit.json";
      description = "Full path to the JSON log file";
    };
  };

  config = mkIf (config.services.icingaweb2.enable && cfg.enable) {
    environment.etc = { "icingaweb2/enabledModules/audit" = { source = "${pkgs.icingaweb2Modules.module-audit}"; }; }
      // optionalAttrs (!cfg.mutableAuditConfig) { "icingaweb2/modules/audit/config.ini".text = configIni; };
  };
}
