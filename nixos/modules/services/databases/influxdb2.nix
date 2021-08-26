{ config, lib, pkgs, ... }:
with lib;
let
  format = pkgs.formats.json { };
  cfg = config.services.influxdb2;
  configFile = format.generate "config.json" cfg.settings;
in
{
  options = {
    services.influxdb2 = {
      enable = mkEnableOption "the influxdb2 server";
      package = mkOption {
        default = pkgs.influxdb2;
        defaultText = "pkgs.influxdb2";
        description = "influxdb2 derivation to use.";
        type = types.package;
      };
      settings = mkOption {
        default = { };
        description = "configuration options for influxdb2, see https://docs.influxdata.com/influxdb/v2.0/reference/config-options for details.";
        type = format.type;
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = !(builtins.hasAttr "bolt-path" cfg.settings) && !(builtins.hasAttr "engine-path" cfg.settings);
      message = "services.influxdb2.config: bolt-path and engine-path should not be set as they are managed by systemd";
    }];
    systemd.services.influxdb2 = {
      description = "InfluxDB is an open-source, distributed, time series database";
      documentation = [ "https://docs.influxdata.com/influxdb/" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        INFLUXD_CONFIG_PATH = "${configFile}";
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/influxd --bolt-path \${STATE_DIRECTORY}/influxd.bolt --engine-path \${STATE_DIRECTORY}/engine";
        StateDirectory = "influxdb2";
        DynamicUser = true;
        CapabilityBoundingSet = "";
        SystemCallFilter = "@system-service";
        LimitNOFILE = 65536;
        KillMode = "control-group";
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ nickcao ];
}
