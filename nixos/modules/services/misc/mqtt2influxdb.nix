{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.mqtt2influxdb;
  filterNull = filterAttrsRecursive (n: v: v != null);
  configFile = (pkgs.formats.yaml {}).generate "mqtt2influxdb.config.yaml" (
    filterNull {
      inherit (cfg) mqtt influxdb;
      points = map filterNull cfg.points;
    }
  );

  pointType = types.submodule {
    options = {
      measurement = mkOption {
        type = types.str;
        description = "Name of the measurement";
      };
      topic = mkOption {
        type = types.str;
        description = "MQTT topic to subscribe to.";
      };
      fields = mkOption {
        type = types.submodule {
          options = {
            value = mkOption {
              type = types.str;
              default = "$.payload";
              description = "Value to be picked up";
            };
            type = mkOption {
              type = with types; nullOr str;
              default = null;
              description = "Type to be picked up";
            };
          };
        };
        description = "Field selector.";
      };
      tags = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = "Tags applied";
      };
    };
  };

  defaultPoints = [
    {
      measurement = "temperature";
      topic = "node/+/thermometer/+/temperature";
      fields.value = "$.payload";
      tags = {
        id = "$.topic[1]";
        channel = "$.topic[3]";
      };
    }
    {
      measurement = "relative-humidity";
      topic = "node/+/hygrometer/+/relative-humidity";
      fields.value = "$.payload";
      tags = {
        id = "$.topic[1]";
        channel = "$.topic[3]";
      };
    }
    {
      measurement = "illuminance";
      topic = "node/+/lux-meter/0:0/illuminance";
      fields.value = "$.payload";
      tags = {
        id = "$.topic[1]";
      };
    }
    {
      measurement = "pressure";
      topic = "node/+/barometer/0:0/pressure";
      fields.value = "$.payload";
      tags = {
        id = "$.topic[1]";
      };
    }
    {
      measurement = "co2";
      topic = "node/+/co2-meter/-/concentration";
      fields.value = "$.payload";
      tags = {
        id = "$.topic[1]";
      };
    }
    {
      measurement = "voltage";
      topic = "node/+/battery/+/voltage";
      fields.value = "$.payload";
      tags = {
        id = "$.topic[1]";
      };
    }
    {
      measurement = "button";
      topic = "node/+/push-button/+/event-count";
      fields.value = "$.payload";
      tags = {
        id = "$.topic[1]";
        channel = "$.topic[3]";
      };
    }
    {
      measurement = "tvoc";
      topic = "node/+/voc-lp-sensor/0:0/tvoc";
      fields.value = "$.payload";
      tags = {
        id = "$.topic[1]";
      };
    }
  ];
in {
  options = {
    services.mqtt2influxdb = {
      enable = mkEnableOption "BigClown MQTT to InfluxDB bridge";
      package = mkPackageOption pkgs ["python3Packages" "mqtt2influxdb"] {};
      environmentFiles = mkOption {
        type = types.listOf types.path;
        default = [];
        example = [ "/run/keys/mqtt2influxdb.env" ];
        description = ''
          File to load as environment file. Environment variables from this file
          will be interpolated into the config file using envsubst with this
          syntax: `$ENVIRONMENT` or `''${VARIABLE}`.
          This is useful to avoid putting secrets into the nix store.
        '';
      };
      mqtt = {
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Host where MQTT server is running.";
        };
        port = mkOption {
          type = types.port;
          default = 1883;
          description = "MQTT server port.";
        };
        username = mkOption {
          type = with types; nullOr str;
          default = null;
          description = "Username used to connect to the MQTT server.";
        };
        password = mkOption {
          type = with types; nullOr str;
          default = null;
          description = ''
            MQTT password.

            It is highly suggested to use here replacement through
            environmentFiles as otherwise the password is put world readable to
            the store.
          '';
        };
        cafile = mkOption {
          type = with types; nullOr path;
          default = null;
          description = "Certification Authority file for MQTT";
        };
        certfile = mkOption {
          type = with types; nullOr path;
          default = null;
          description = "Certificate file for MQTT";
        };
        keyfile = mkOption {
          type = with types; nullOr path;
          default = null;
          description = "Key file for MQTT";
        };
      };
      influxdb = {
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Host where InfluxDB server is running.";
        };
        port = mkOption {
          type = types.port;
          default = 8086;
          description = "InfluxDB server port";
        };
        database = mkOption {
          type = types.str;
          description = "Name of the InfluxDB database.";
        };
        username = mkOption {
          type = with types; nullOr str;
          default = null;
          description = "Username for InfluxDB login.";
        };
        password = mkOption {
          type = with types; nullOr str;
          default = null;
          description = ''
            Password for InfluxDB login.

            It is highly suggested to use here replacement through
            environmentFiles as otherwise the password is put world readable to
            the store.
            '';
        };
        ssl = mkOption {
          type = types.bool;
          default = false;
          description = "Use SSL to connect to the InfluxDB server.";
        };
        verify_ssl = mkOption {
          type = types.bool;
          default = true;
          description = "Verify SSL certificate when connecting to the InfluxDB server.";
        };
      };
      points = mkOption {
        type = types.listOf pointType;
        default = defaultPoints;
        description = "Points to bridge from MQTT to InfluxDB.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.bigclown-mqtt2influxdb = let
      envConfig = cfg.environmentFiles != [];
      finalConfig = if envConfig
        then "$RUNTIME_DIRECTORY/mqtt2influxdb.config.yaml"
        else configFile;
    in {
      description = "BigClown MQTT to InfluxDB bridge";
      wantedBy = ["multi-user.target"];
      wants = mkIf config.services.mosquitto.enable ["mosquitto.service"];
      preStart = ''
        umask 077
        ${pkgs.envsubst}/bin/envsubst -i "${configFile}" -o "${finalConfig}"
      '';
      serviceConfig = {
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = "${lib.getExe cfg.package} -dc ${finalConfig}";
        RuntimeDirectory = "mqtt2influxdb";
      };
    };
  };
}
