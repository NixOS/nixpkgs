{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.dmarc;

  json = builtins.toJSON {
    inherit (cfg) folders port;
    listen_addr = cfg.listenAddress;
    storage_path = "$STATE_DIRECTORY";
    imap = (builtins.removeAttrs cfg.imap [ "passwordFile" ]) // { password = "$IMAP_PASSWORD"; use_ssl = true; };
    poll_interval_seconds = cfg.pollIntervalSeconds;
    deduplication_max_seconds = cfg.deduplicationMaxSeconds;
    logging = {
      version = 1;
      disable_existing_loggers = false;
    };
  };
in {
  port = 9797;
  extraOpts = {
    imap = {
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Hostname of IMAP server to connect to.
        '';
      };
      port = mkOption {
        type = types.port;
        default = 993;
        description = ''
          Port of the IMAP server to connect to.
        '';
      };
      username = mkOption {
        type = types.str;
        example = "postmaster@example.org";
        description = ''
          Login username for the IMAP connection.
        '';
      };
      passwordFile = mkOption {
        type = types.str;
        example = "/run/secrets/dovecot_pw";
        description = ''
          File containing the login password for the IMAP connection.
        '';
      };
    };
    folders = {
      inbox = mkOption {
        type = types.str;
        default = "INBOX";
        description = ''
          IMAP mailbox that is checked for incoming DMARC aggregate reports
        '';
      };
      done = mkOption {
        type = types.str;
        default = "Archive";
        description = ''
          IMAP mailbox that successfully processed reports are moved to.
        '';
      };
      error = mkOption {
        type = types.str;
        default = "Invalid";
        description = ''
          IMAP mailbox that emails are moved to that could not be processed.
        '';
      };
    };
    pollIntervalSeconds = mkOption {
      type = types.ints.unsigned;
      default = 60;
      description = ''
        How often to poll the IMAP server in seconds.
      '';
    };
    deduplicationMaxSeconds = mkOption {
      type = types.ints.unsigned;
      default = 604800;
      defaultText = "7 days (in seconds)";
      description = ''
        How long individual report IDs will be remembered to avoid
        counting double delivered reports twice.
      '';
    };
    debug = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to declare enable <literal>--debug</literal>.
      '';
    };
  };
  serviceOpts = {
    path = with pkgs; [ envsubst coreutils ];
    serviceConfig = {
      StateDirectory = "prometheus-dmarc-exporter";
      WorkingDirectory = "/var/lib/prometheus-dmarc-exporter";
      ExecStart = "${pkgs.writeShellScript "setup-cfg" ''
        export IMAP_PASSWORD="$(<${cfg.imap.passwordFile})"
        envsubst \
          -i ${pkgs.writeText "dmarc-exporter.json.template" json} \
          -o ''${STATE_DIRECTORY}/dmarc-exporter.json

        exec ${pkgs.prometheus-dmarc-exporter}/bin/prometheus-dmarc-exporter \
          --configuration /var/lib/prometheus-dmarc-exporter/dmarc-exporter.json \
          ${optionalString cfg.debug "--debug"}
      ''}";
    };
  };
}
