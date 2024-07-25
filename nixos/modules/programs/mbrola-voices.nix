{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.programs.mbrola-voices;
in
{
  options.programs.mbrola-voices = {
    enable = lib.mkEnableOption "link MBROLA speech synthesizer voices installed through [](#opt-environment.systemPackages)";

    installDefault = lib.mkOption {
      description = "Whether to install default MBROLA voices";
      type = lib.types.bool;
      default = cfg.enable;
      defaultText = "config.programs.mbrola-voices.enable";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.optionals cfg.installDefault [
      pkgs.mbrola-voices
    ];

    environment.pathsToLink = [ "/share/mbrola" ];
  };
}
