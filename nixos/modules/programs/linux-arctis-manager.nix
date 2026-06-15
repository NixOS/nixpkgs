{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.linux-arctis-manager;
  inherit (lib)
    mkEnableOption
    mkIf
    maintainers
    mkPackageOption
    ;
in
{
  options.programs.linux-arctis-manager = {
    enable = mkEnableOption "Linux Arctis Manager the opensource UI for Stealseries HeadSets";
    package = mkPackageOption pkgs "linux-arctis-manager" { };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ cfg.package ];

    environment.systemPackages = [ cfg.package ];

    systemd.user.services.arctis-manager = {
      description = "Arctis Manager";
      unitConfig = {
        StartLimitInterval = "1min";
        StartLimitBurst = 5;
      };
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe' cfg.package "lam-daemon"}";
        Restart = "on-failure";
        RestartSec = "5";
      };
    };

    meta = {
      maintainers = [ maintainers.Svenum ];
    };
  };
}
