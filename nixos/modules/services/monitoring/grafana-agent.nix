{ lib, pkgs, config, generators, ... }:
with lib;
let
  cfg = config.services.grafana-agent;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "grafana-agent.yaml" cfg.settings;
in
{
  meta = {
    maintainers = with maintainers; [ flokli zimbatm ];
  };

  options.services.grafana-agent = {
    enable = mkEnableOption "grafana-agent";

    package = mkOption {
      type = types.package;
      default = pkgs.grafana-agent;
      defaultText = "pkgs.grafana-agent";
      description = lib.mdDoc "The grafana-agent package to use.";
    };

    credentials = mkOption {
      description = lib.mdDoc ''
        Credentials to load at service startup. Keys that are UPPER_SNAKE will be loaded as env vars. Values are absolute paths to the credentials.
      '';
      type = types.attrsOf types.str;
      default = { };

      example = {
        logs_remote_write_password = "/run/keys/grafana_agent_logs_remote_write_password";
        LOGS_REMOTE_WRITE_URL = "/run/keys/grafana_agent_logs_remote_write_url";
        LOGS_REMOTE_WRITE_USERNAME = "/run/keys/grafana_agent_logs_remote_write_username";
        metrics_remote_write_password = "/run/keys/grafana_agent_metrics_remote_write_password";
        METRICS_REMOTE_WRITE_URL = "/run/keys/grafana_agent_metrics_remote_write_url";
        METRICS_REMOTE_WRITE_USERNAME = "/run/keys/grafana_agent_metrics_remote_write_username";
      };
    };

    settings = mkOption {
      description = lib.mdDoc ''
        Configuration for `grafana-agent`.

        See https://grafana.com/docs/agent/latest/configuration/
      '';

      type = types.submodule {
        freeformType = settingsFormat.type;
      };

      default = { };
      defaultText = ''
        metrics = {
          wal_directory = "\''${STATE_DIRECTORY}";
          global.scrape_interval = "5s";
        };
        integrations = {
          agent.enabled = true;
          agent.scrape_integration = true;
          node_exporter.enabled = true;
          replace_instance_label = true;
        };
      '';
      example = {
        metrics.global.remote_write = [{
          url = "\${METRICS_REMOTE_WRITE_URL}";
          basic_auth.username = "\${METRICS_REMOTE_WRITE_USERNAME}";
          basic_auth.password_file = "\${CREDENTIALS_DIRECTORY}/metrics_remote_write_password";
        }];
        logs.configs = [{
          name = "default";
          scrape_configs = [
            {
              job_name = "journal";
              journal = {
                max_age = "12h";
                labels.job = "systemd-journal";
              };
              relabel_configs = [
                {
                  source_labels = [ "__journal__systemd_unit" ];
                  target_label = "systemd_unit";
                }
                {
                  source_labels = [ "__journal__hostname" ];
                  target_label = "nodename";
                }
                {
                  source_labels = [ "__journal_syslog_identifier" ];
                  target_label = "syslog_identifier";
                }
              ];
            }
          ];
          positions.filename = "\${STATE_DIRECTORY}/loki_positions.yaml";
          clients = [{
            url = "\${LOGS_REMOTE_WRITE_URL}";
            basic_auth.username = "\${LOGS_REMOTE_WRITE_USERNAME}";
            basic_auth.password_file = "\${CREDENTIALS_DIRECTORY}/logs_remote_write_password";
          }];
        }];
      };
    };
  };

  config = mkIf cfg.enable {
    services.grafana-agent.settings = {
      # keep this in sync with config.services.grafana-agent.settings.defaultText.
      metrics = {
        wal_directory = mkDefault "\${STATE_DIRECTORY}";
        global.scrape_interval = mkDefault "5s";
      };
      integrations = {
        agent.enabled = mkDefault true;
        agent.scrape_integration = mkDefault true;
        node_exporter.enabled = mkDefault true;
        replace_instance_label = mkDefault true;
      };
    };

    systemd.services.grafana-agent = {
      wantedBy = [ "multi-user.target" ];
      script = ''
        set -euo pipefail
        shopt -u nullglob

        # Load all credentials into env if they are in UPPER_SNAKE form.
        if [[ -n "''${CREDENTIALS_DIRECTORY:-}" ]]; then
          for file in "$CREDENTIALS_DIRECTORY"/*; do
            key=$(basename "$file")
            if [[ $key =~ ^[A-Z0-9_]+$ ]]; then
              echo "Environ $key"
              export "$key=$(< "$file")"
            fi
          done
        fi

        # We can't use Environment=HOSTNAME=%H, as it doesn't include the domain part.
        export HOSTNAME=$(< /proc/sys/kernel/hostname)

        exec ${cfg.package}/bin/agent -config.expand-env -config.file ${configFile}
      '';
      serviceConfig = {
        Restart = "always";
        DynamicUser = true;
        RestartSec = 2;
        SupplementaryGroups = [
          # allow to read the systemd journal for loki log forwarding
          "systemd-journal"
        ];
        StateDirectory = "grafana-agent";
        LoadCredential = lib.mapAttrsToList (key: value: "${key}:${value}") cfg.credentials;
        Type = "simple";
      };
    };
  };
}
