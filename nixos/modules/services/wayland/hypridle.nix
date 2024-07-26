{ lib, pkgs, config, ... }:

let
  cfg = config.services.hypridle;
in
{
  options.services.hypridle = {
    enable = lib.mkEnableOption "hypridle, Hyprland's idle daemon";
    package = lib.mkPackageOption pkgs "hypridle" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    systemd.user.services.hypridle = {
      description = "Hypridle idle daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      script = lib.getExe cfg.package;
    };
  };

  meta.maintainers = with lib.maintainers; [ johnrtitor ];
}
