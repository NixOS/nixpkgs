{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.espeakup;
  inherit (lib)
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    types
    ;
in
{
  options.services.espeakup = {
    enable = mkEnableOption "Espeakup screen reader";
    package = mkPackageOption pkgs "espeakup" { };
    defaultVoice = mkOption {
      type = types.str;
      default = "en-gb";
      description = "Default voice for espeakup";
    };
  };
  meta.maintainers = with lib.maintainers; [ ndarilek ];
  config = mkIf cfg.enable {
    boot.kernelModules = [ "speakup_soft" ];
    systemd.packages = [ cfg.package ];
    systemd.services.espeakup = {
      wantedBy = [ "sound.target" ];
      environment = {
        default_voice = cfg.defaultVoice;
      };
      serviceConfig = {
        ExecStartPre = "";
      };
    };
  };
}
