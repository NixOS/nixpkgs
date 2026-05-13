{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.watchdogd;

  mkPluginOpts = plugin: defWarn: defCrit: {
    enabled = lib.mkEnableOption "watchdogd plugin ${plugin}";
    interval = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 300;
      description = ''
        Amount of seconds between every poll.
      '';
    };
    logmark = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to log current stats every poll interval.
      '';
    };
    warning = lib.mkOption {
      type = lib.types.numbers.nonnegative;
      default = defWarn;
      description = ''
        The high watermark level. Alert sent to log.
      '';
    };
    critical = lib.mkOption {
      type = lib.types.numbers.nonnegative;
      default = defCrit;
      description = ''
        The critical watermark level. Alert sent to log, followed by reboot or script action.
      '';
    };
  };
in
{
  options.services.watchdogd = {
    enable = lib.mkEnableOption "watchdogd, an advanced system & process supervisor";
    package = lib.mkPackageOption pkgs "watchdogd" { };

    settings = lib.mkOption {
      type =
        with lib.types;
        submodule {
          freeformType =
            let
              valueType = oneOf [
                bool
                int
                float
                str
              ];
            in
            attrsOf (either valueType (attrsOf valueType));

          options = {
            timeout = lib.mkOption {
              type = types.ints.unsigned;
              default = 15;
              description = ''
                The WDT timeout before reset.
              '';
            };
            interval = lib.mkOption {
              type = types.ints.unsigned;
              default = 5;
              description = ''
                The kick interval, i.e. how often {manpage}`watchdogd(8)` should reset the WDT timer.
              '';
            };

            safe-exit = lib.mkOption {
              type = types.bool;
              default = true;
              description = ''
                With {var}`safeExit` enabled, the daemon will ask the driver to disable the WDT before exiting.
                However, some WDT drivers (or hardware) may not support this.
              '';
            };

            filenr = mkPluginOpts "filenr" 0.9 1.0;

            loadavg = mkPluginOpts "loadavg" 1.0 2.0;

            meminfo = mkPluginOpts "meminfo" 0.9 0.95;
          };
        };
      default = { };
      description = ''
        Configuration to put in {file}`watchdogd.conf`.
        See {manpage}`watchdogd.conf(5)` for more details.
      '';
    };
  };

  config =
    let
      toConfig = attrs: lib.concatStringsSep "\n" (lib.mapAttrsToList toValue attrs);

      toValue =
        name: value:
        if lib.isAttrs value then
          lib.pipe value [
            (lib.mapAttrsToList toValue)
            (map (s: "  ${s}"))
            (lib.concatStringsSep "\n")
            (s: "${name} {\n${s}\n}")
          ]
        else if lib.isBool value then
          "${name} = ${lib.boolToString value}"
        else if
          lib.any (f: f value) [
            lib.isString
            lib.isInt
            lib.isFloat
          ]
        then
          "${name} = ${toString value}"
        else
          throw ''
            Found invalid type in `services.watchdogd.settings`: '${lib.typeOf value}'
          '';

      watchdogdConf = pkgs.writeText "watchdogd.conf" (toConfig cfg.settings);
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      systemd.services.watchdogd = {
        documentation = [
          "man:watchdogd(8)"
          "man:watchdogd.conf(5)"
        ];
        wantedBy = [ "multi-user.target" ];
        description = "Advanced system & process supervisor";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${cfg.package}/bin/watchdogd -n -f ${watchdogdConf}";
        };
      };
    };

  meta.maintainers = with lib.maintainers; [ vifino ];
}
