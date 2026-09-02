{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    ;
  cfg = config.services.hyprwhspr-rs;
in
{
  options.services.hyprwhspr-rs = {
    enable = mkEnableOption "hyprwhspr-rs";
    package = mkPackageOption pkgs "hyprwhspr-rs" { };

    environmentFile = mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/path/to/hyprwhspr_secret_file";
      description = "File containing API keys (GROQ_API_KEY, GEMINI_API_KEY) for remote transcription.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.hyprwhspr-rs = {
      description = "Native speech-to-text voice dictation for Hyprland";

      after = [
        "graphical-session.target"
        "pipewire.service"
      ];
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        LoadCredential = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
      };
    };
  };
}
