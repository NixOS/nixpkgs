# This module implements a systemd service for running journaldriver,
# a log forwarding agent that sends logs from journald to Stackdriver
# Logging.
#
# It can be enabled without extra configuration when running on GCP.
# On machines hosted elsewhere, the other configuration options need
# to be set.
#
# For further information please consult the documentation in the
# upstream repository at: https://github.com/tazjin/journaldriver/

{ config, lib, pkgs, ...}:

with lib; let cfg = config.services.journaldriver;
in {
  options.services.journaldriver = {
    enable = mkOption {
      type        = types.bool;
      default     = false;
      description = lib.mdDoc ''
        Whether to enable journaldriver to forward journald logs to
        Stackdriver Logging.
      '';
    };

    logLevel = mkOption {
      type        = types.str;
      default     = "info";
      description = lib.mdDoc ''
        Log level at which journaldriver logs its own output.
      '';
    };

    logName = mkOption {
      type        = with types; nullOr str;
      default     = null;
      description = lib.mdDoc ''
        Configures the name of the target log in Stackdriver Logging.
        This option can be set to, for example, the hostname of a
        machine to improve the user experience in the logging
        overview.
      '';
    };

    googleCloudProject = mkOption {
      type        = with types; nullOr str;
      default     = null;
      description = lib.mdDoc ''
        Configures the name of the Google Cloud project to which to
        forward journald logs.

        This option is required on non-GCP machines, but should not be
        set on GCP instances.
      '';
    };

    logStream = mkOption {
      type        = with types; nullOr str;
      default     = null;
      description = lib.mdDoc ''
        Configures the name of the Stackdriver Logging log stream into
        which to write journald entries.

        This option is required on non-GCP machines, but should not be
        set on GCP instances.
      '';
    };

    applicationCredentials = mkOption {
      type        = with types; nullOr path;
      default     = null;
      description = lib.mdDoc ''
        Path to the service account private key (in JSON-format) used
        to forward log entries to Stackdriver Logging on non-GCP
        instances.

        This option is required on non-GCP machines, but should not be
        set on GCP instances.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.journaldriver = {
      description = "Stackdriver Logging journal forwarder";
      script      = "${pkgs.journaldriver}/bin/journaldriver";
      wants       = [ "network-online.target" ];
      after       = [ "network-online.target" ];
      wantedBy    = [ "multi-user.target" ];

      serviceConfig = {
        Restart        = "always";
        DynamicUser    = true;

        # This directive lets systemd automatically configure
        # permissions on /var/lib/journaldriver, the directory in
        # which journaldriver persists its cursor state.
        StateDirectory = "journaldriver";

        # This group is required for accessing journald.
        SupplementaryGroups = "systemd-journal";
      };

      environment = {
        RUST_LOG                       = cfg.logLevel;
        LOG_NAME                       = cfg.logName;
        LOG_STREAM                     = cfg.logStream;
        GOOGLE_CLOUD_PROJECT           = cfg.googleCloudProject;
        GOOGLE_APPLICATION_CREDENTIALS = cfg.applicationCredentials;
      };
    };
  };
}
