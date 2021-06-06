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
      special = enum [ "level auto" "level full-speed" "level disengage" ];
    in
      tuple [ (either level special) level level ];

  # sensor or fan config
  sensorType = name: types.submodule {
    freeformType = types.attrsOf settingsFormat.type;
    options = {
      type = mkOption {
        type = types.enum [ "hwmon" "atasmart" "tpacpi" "nvml" ];
        description = ''
          The ${name} type, can be
          <literal>hwmon</literal> for standard ${name}s,

          <literal>atasmart</literal> to read the temperature via
          S.M.A.R.T (requires smartSupport to be enabled),

          <literal>tpacpi</literal> for the legacy thinkpac_acpi driver, or

          <literal>nvml</literal> for the (proprietary) nVidia driver.
        '';
      };
      query = mkOption {
        type = types.str;
        description = ''
          The query string used to match one or more ${name}s: can be
          a fullpath to the temperature file (single ${name}) or a fullpath
          to a driver directory (multiple ${name}s).

          <note><para>
            When multiple ${name}s match, the query can be restricted using the
            <option>name</option> or <option>indices</option> options.
          </para></note>
        '';
      };
      indices = mkOption {
        type = with types; nullOr (listOf ints.unsigned);
        default = null;
        description = ''
          A list of ${name}s to pick in case multiple ${name}s match the query.

          <note><para>Indices start from 0.</para></note>
        '';
      };
    } // optionalAttrs (name == "sensor") {
      correction = mkOption {
        type = with types; nullOr (listOf int);
        default = null;
        description = ''
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
    <note><para>
      This section slightly departs from the thinkfan.conf syntax.
      The type and path must be specified like this:
      <literal>
        type = "tpacpi";
        query = "/proc/acpi/ibm/${name}";
      </literal>
      instead of a single declaration like:
      <literal>
        - tpacpi: /proc/acpi/ibm/${name}
      </literal>
    </para></note>
  '';

in {

  options = {

    services.thinkfan = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable thinkfan, a fan control program.

          <note><para>
            This module targets IBM/Lenovo thinkpads by default, for
            other hardware you will have configure it more carefully.
          </para></note>
        '';
        relatedPackages = [ "thinkfan" ];
      };

      smartSupport = mkOption {
        type = types.bool;
        default = false;
        description = ''
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
        description = ''
          List of temperature sensors thinkfan will monitor.
        '' + syntaxNote "thermal";
      };

      fans = mkOption {
        type = types.listOf (sensorType "fan");
        default = [
          { type = "tpacpi";
            query = "/proc/acpi/ibm/fan";
          }
        ];
        description = ''
          List of fans thinkfan will control.
        '' + syntaxNote "fan";
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
        description = ''
          [LEVEL LOW HIGH]

          LEVEL is the fan level to use: it can be an integer (0-7 with thinkpad_acpi),
          "level auto" (to keep the default firmware behavior), "level full-speed" or
          "level disengage" (to run the fan as fast as possible).
          LOW is the temperature at which to step down to the previous level.
          HIGH is the temperature at which to step up to the next level.
          All numbers are integers.
        '';
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "-b" "0" ];
        description = ''
          A list of extra command line arguments to pass to thinkfan.
          Check the thinkfan(1) manpage for available arguments.
        '';
      };

      settings = mkOption {
        type = types.attrsOf settingsFormat.type;
        default = { };
        description = ''
          Thinkfan settings. Use this option to configure thinkfan
          settings not exposed in a NixOS option or to bypass one.
          Before changing this, read the <literal>thinkfan.conf(5)</literal>
          manpage and take a look at the example config file at
          <link xlink:href="https://github.com/vmatare/thinkfan/blob/master/examples/thinkfan.yaml"/>
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

      # must be added manually, see issue #81138
      thinkfan.wantedBy = [ "multi-user.target" ];
      thinkfan-wakeup.wantedBy = [ "sleep.target" ];
      thinkfan-sleep.wantedBy = [ "sleep.target" ];
    };

    boot.extraModprobeConfig = "options thinkpad_acpi experimental=1 fan_control=1";

  };
}
