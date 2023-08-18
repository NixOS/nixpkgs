{ config, lib, pkgs, ... }:

let
  inherit
    (lib)
    escapeShellArg
    hasAttr
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  format = pkgs.formats.json { };
  cfg = config.services.influxdb2;
  configFile = format.generate "config.json" cfg.settings;
in
{
  options = {
    services.influxdb2 = {
      enable = mkEnableOption (lib.mdDoc "the influxdb2 server");

      package = mkOption {
        default = pkgs.influxdb2-server;
        defaultText = literalExpression "pkgs.influxdb2";
        description = lib.mdDoc "influxdb2 derivation to use.";
        type = types.package;
      };

      settings = mkOption {
        default = { };
        description = lib.mdDoc ''configuration options for influxdb2, see <https://docs.influxdata.com/influxdb/v2.0/reference/config-options> for details.'';
        type = format.type;
      };

      provision = {
        enable = mkEnableOption "initial database setup and provisioning";

        initialSetup = {
          organization = mkOption {
            type = types.str;
            example = "main";
            description = "Primary organization name";
          };

          bucket = mkOption {
            type = types.str;
            example = "example";
            description = "Primary bucket name";
          };

          username = mkOption {
            type = types.str;
            default = "admin";
            description = "Primary username";
          };

          retention = mkOption {
            type = types.str;
            default = "0";
            description = ''
              The duration for which the bucket will retain data (0 is infinite).
              Accepted units are `ns` (nanoseconds), `us` or `µs` (microseconds), `ms` (milliseconds),
              `s` (seconds), `m` (minutes), `h` (hours), `d` (days) and `w` (weeks).
            '';
          };

          passwordFile = mkOption {
            type = types.path;
            description = "Password for primary user. Don't use a file from the nix store!";
          };

          tokenFile = mkOption {
            type = types.path;
            description = "API Token to set for the admin user. Don't use a file from the nix store!";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(hasAttr "bolt-path" cfg.settings) && !(hasAttr "engine-path" cfg.settings);
        message = "services.influxdb2.config: bolt-path and engine-path should not be set as they are managed by systemd";
      }
    ];

    systemd.services.influxdb2 = {
      description = "InfluxDB is an open-source, distributed, time series database";
      documentation = [ "https://docs.influxdata.com/influxdb/" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        INFLUXD_CONFIG_PATH = configFile;
        ZONEINFO = "${pkgs.tzdata}/share/zoneinfo";
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/influxd --bolt-path \${STATE_DIRECTORY}/influxd.bolt --engine-path \${STATE_DIRECTORY}/engine";
        StateDirectory = "influxdb2";
        User = "influxdb2";
        Group = "influxdb2";
        CapabilityBoundingSet = "";
        SystemCallFilter = "@system-service";
        LimitNOFILE = 65536;
        KillMode = "control-group";
        Restart = "on-failure";
        LoadCredential = mkIf cfg.provision.enable [
          "admin-password:${cfg.provision.initialSetup.passwordFile}"
          "admin-token:${cfg.provision.initialSetup.tokenFile}"
        ];
      };

      path = [pkgs.influxdb2-cli];

      # Mark if this is the first startup so postStart can do the initial setup
      preStart = mkIf cfg.provision.enable ''
        if ! test -e "$STATE_DIRECTORY/influxd.bolt"; then
          touch "$STATE_DIRECTORY/.first_startup"
        fi
      '';

      postStart = let
        initCfg = cfg.provision.initialSetup;
      in mkIf cfg.provision.enable (
        ''
          set -euo pipefail
          export INFLUX_HOST="http://"${escapeShellArg (cfg.settings.http-bind-address or "localhost:8086")}

          # Wait for the influxdb server to come online
          count=0
          while ! influx ping &>/dev/null; do
            if [ "$count" -eq 300 ]; then
              echo "Tried for 30 seconds, giving up..."
              exit 1
            fi

            if ! kill -0 "$MAINPID"; then
              echo "Main server died, giving up..."
              exit 1
            fi

            sleep 0.1
            count=$((count++))
          done

          # Do the initial database setup. Pass /dev/null as configs-path to
          # avoid saving the token as the active config.
          if test -e "$STATE_DIRECTORY/.first_startup"; then
            influx setup \
              --configs-path /dev/null \
              --org ${escapeShellArg initCfg.organization} \
              --bucket ${escapeShellArg initCfg.bucket} \
              --username ${escapeShellArg initCfg.username} \
              --password "$(< "$CREDENTIALS_DIRECTORY/admin-password")" \
              --token "$(< "$CREDENTIALS_DIRECTORY/admin-token")" \
              --retention ${escapeShellArg initCfg.retention} \
              --force >/dev/null

            rm -f "$STATE_DIRECTORY/.first_startup"
          fi
        ''
      );
    };

    users.extraUsers.influxdb2 = {
      isSystemUser = true;
      group = "influxdb2";
    };

    users.extraGroups.influxdb2 = {};
  };

  meta.maintainers = with lib.maintainers; [ nickcao oddlama ];
}
