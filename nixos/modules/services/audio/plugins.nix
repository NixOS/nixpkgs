{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption mdDoc types;
  cfg = config.services.audio-plugins;

  env = {
    LADSPA_PATH = lib.makeSearchPathOutput "lib" "lib/ladspa" cfg.ladspa-plugins;
    LV2_PATH = lib.makeSearchPathOutput "lib" "lib/lv2" cfg.lv2-plugins;
  };
in
{
  options.services.audio-plugins = {
    ladspa-plugins = mkOption {
      type = types.listOf types.package;
      default = [];
      description = mdDoc ''
        A list of LADSPA plugins to provide to the environment.
      '';
    };
    lv2-plugins = mkOption {
      type = types.listOf types.package;
      default = [];
      description = mdDoc ''
        A list of LV2 plugins to provide to the environment.
      '';
    };
  };

  config = mkIf ( [] != cfg.ladspa-plugins ++ cfg.lv2-plugins ) {
      environment.variables = env;
      systemd.user.services.pipewire.environment =
        mkIf (config.services.pipewire.enable && !config.services.pipewire.systemWide) env;
      systemd.services.pipewire.environment =
        mkIf (config.services.pipewire.enable && config.services.pipewire.systemWide) env;
      systemd.user.services.pulseaudio.environment =
        mkIf (config.hardware.pulseaudio.enable && !config.hardware.pulseaudio.systemWide) env;
      systemd.services.pulseaudio.environment =
        mkIf (config.hardware.pulseaudio.enable && config.hardware.pulseaudio.systemWide) env;
  };
}
