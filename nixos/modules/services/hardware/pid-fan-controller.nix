{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.pid-fan-controller;
  settingsFormat = pkgs.formats.json { };
in
{
  options.services.pid-fan-controller = {
    enable = lib.mkEnableOption "the PID fan controller, which controls the configured fans by running a closed-loop PID control loop";
    package = lib.mkPackageOption pkgs "pid-fan-controller" { };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.either settingsFormat.type (lib.types.listOf settingsFormat.type);
      };
      default = { };
      description = ''
        Configuration for pid-fan-controller, see
        <https://github.com/zimward/pid-fan-controller>
        for supported values.
      '';
    };
  };

  config =
    let
      oldConfig = cfg.settings ? heatSources;
      configFile = settingsFormat.generate "pid-fan-settings.json" (
        if oldConfig then
          throw ''
            `pid-fan-controller` is no longer deeply configured.
            Please switch to using underscore case as shown in the upstream documentation.
          ''
        else
          cfg.settings
      );
    in
    lib.mkIf cfg.enable {
      systemd.packages = [ cfg.package ];
      systemd.services.pid-fan-controller.environment.PID_FAN_CONFIG = toString configFile;
      systemd.services.pid-fan-controller.wantedBy = [ "multi-user.target" ];
    };
  meta.maintainers = with lib.maintainers; [ zimward ];
}
