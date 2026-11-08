{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;

  cfg = config.services.bifroest;
  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.bifroest = {
    enable = mkEnableOption "Engity's Bifröst, a feature-rich SSH server capable of authenticating users via Oauth2 Device Authorization Grant";
    pakckage = mkPackageOption pkgs "bifroest" { };
    settings = mkOption {
      inherit (settingsFormat) type;
      description = "Structured settings for Bifröst. Please see the [configuration reference](https://bifroest.engity.org/reference/configuration/) upstream.";
      default = { };
    };
  };
  config = mkIf cfg.enable {
    systemd.services.bifroest = {
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        Description = "Bifröst Server";
        Documentation = "https://bifroest.engity.org";
      };
      serviceConfig = {
        ExecStart = "${getExe cfg.package} run --configuration=${settingsFormat.generate "bifroest.yaml" cfg.settings}";
        Restart = "always";
        Type = "simple";
      };
    };
  };
}
