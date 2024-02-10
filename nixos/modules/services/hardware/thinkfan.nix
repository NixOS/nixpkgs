{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.thinkfan;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "thinkfan.yaml" cfg.settings;
  thinkfan = pkgs.thinkfan.override { inherit (cfg) smartSupport; };

  # fan-speed and temperature levels
  levelType = with types;
    let
      tuple = ts: mkOptionType {
        name = "tuple";
        merge = mergeOneOption;
        check = xs: all id (zipListsWith (t: x: t.check x) ts xs);
        description = "tuple of" + concatMapStrings (t: " (${t.description})") ts;
      };
      level = ints.unsigned;
      special = enum [ "level auto" "level full-speed" "level disengaged" ];
    in
      tuple [ (either level special) level level ];

  # sensor or fan config
  sensorType = name: types.submodule {
    freeformType = types.attrsOf settingsFormat.type;
    options = {
      type = mkOption {
        type = types.enum [ "hwmon" "atasmart" "tpacpi" "nvml" ];
        description = lib.mdDoc ''
          The ${name} type, can be
          `hwmon` for standard ${name}s,

          `atasmart` to read the temperature via
          S.M.A.R.T (requires smartSupport to be enabled),

          `tpacpi` for the legacy thinkpac_acpi driver, or

          `nvml` for the (proprietary) nVidia driver.
        '';
      };
      query = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The query string used to match one or more ${name}s: can be
          a fullpath to the temperature file (single ${name}) or a fullpath
          to a driver directory (multiple ${name}s).

          ::: {.note}
          When multiple ${name}s match, the query can be restricted using the
          {option}`name` or {option}`indices` options.
          :::
        '';
      };
      indices = mkOption {
        type = with types; nullOr (listOf ints.unsigned);
        default = null;
        description = lib.mdDoc ''
          A list of ${name}s to pick in case multiple ${name}s match the query.

          ::: {.note}
          Indices start from 0.
          :::
        '';
      };
    } // optionalAttrs (name == "sensor") {
      correction = mkOption {
        type = with types; nullOr (listOf int);
        default = null;
        description = lib.mdDoc ''
          A list of values to be added to the temperature of each sensor,
          can be used to equalize small discrepancies in temperature ratings.
        '';
      };
    };
  };

  # removes NixOS special and unused attributes
  sensorToConf = { type, query, ... }@args:
    (filterAttrs (k: v: v != null && !(elem k ["type" "query"])) args)
    // { "${type}" = query; };

  syntaxNote = name: ''
    ::: {.note}
    This section slightly departs from the thinkfan.conf syntax.
    The type and path must be specified like this:
    ```
      type = "tpacpi";
      query = "/proc/acpi/ibm/${name}";
    ```
    instead of a single declaration like:
    ```
      - tpacpi: /proc/acpi/ibm/${name}
    ```
    :::
  '';

in {

  options = {

    services.thinkfan = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable thinkfan, a fan control program.

          ::: {.note}
          This module targets IBM/Lenovo thinkpads by default, for
          other hardware you will have configure it more carefully.
          :::
        '';
        relatedPackages = [ "thinkfan" ];
      };

      smartSupport = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to build thinkfan with S.M.A.R.T. support to read temperatures
          directly from hard disks.
        '';
      };

      sensors = mkOption {
        type = types.listOf (sensorType "sensor");
        default = [
          { type = "tpacpi";
            query = "/proc/acpi/ibm/thermal";
          }
        ];
        description = lib.mdDoc ''
          List of temperature sensors thinkfan will monitor.

          ${syntaxNote "thermal"}
        '';
      };

      fans = mkOption {
        type = types.listOf (sensorType "fan");
        default = [
          { type = "tpacpi";
            query = "/proc/acpi/ibm/fan";
          }
        ];
        description = lib.mdDoc ''
          List of fans thinkfan will control.

          ${syntaxNote "fan"}
        '';
      };

      levels = mkOption {
        type = types.listOf levelType;
        default = [
          [0  0   55]
          [1  48  60]
          [2  50  61]
          [3  52  63]
          [6  56  65]
          [7  60  85]
          ["level auto" 80 32767]
        ];
        description = lib.mdDoc ''
          [LEVEL LOW HIGH]

          LEVEL is the fan level to use: it can be an integer (0-7 with thinkpad_acpi),
          "level auto" (to keep the default firmware behavior), "level full-speed" or
          "level disengaged" (to run the fan as fast as possible).
          LOW is the temperature at which to step down to the previous level.
          HIGH is the temperature at which to step up to the next level.
          All numbers are integers.
        '';
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "-b" "0" ];
        description = lib.mdDoc ''
          A list of extra command line arguments to pass to thinkfan.
          Check the thinkfan(1) manpage for available arguments.
        '';
      };

      settings = mkOption {
        type = types.attrsOf settingsFormat.type;
        default = { };
        description = lib.mdDoc ''
          Thinkfan settings. Use this option to configure thinkfan
          settings not exposed in a NixOS option or to bypass one.
          Before changing this, read the `thinkfan.conf(5)`
          manpage and take a look at the example config file at
          <https://github.com/vmatare/thinkfan/blob/master/examples/thinkfan.yaml>
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ thinkfan ];

    services.thinkfan.settings = mapAttrs (k: v: mkDefault v) {
      sensors = map sensorToConf cfg.sensors;
      fans    = map sensorToConf cfg.fans;
      levels  = cfg.levels;
    };

    systemd.packages = [ thinkfan ];

    systemd.services = {
      thinkfan.environment.THINKFAN_ARGS = escapeShellArgs ([ "-c" configFile ] ++ cfg.extraArgs);
      thinkfan.serviceConfig.Restart = "on-failure";
      thinkfan.serviceConfig.RestartSec = "30s";

      # must be added manually, see issue #81138
      thinkfan.wantedBy = [ "multi-user.target" ];
      thinkfan-wakeup.wantedBy = [ "sleep.target" ];
      thinkfan-sleep.wantedBy = [ "sleep.target" ];
    };

    boot.extraModprobeConfig = "options thinkpad_acpi experimental=1 fan_control=1";

  };
}
