{ lib, pkgs, config, ... }:

let
  cfg = config.programs.hyprlock;
in
{
  options.programs.hyprlock = {
    enable = lib.mkEnableOption "hyprlock, Hyprland's GPU-accelerated screen locking utility";
    package = lib.mkPackageOption pkgs "hyprlock" { };
    hypridlePackage = lib.mkPackageOption pkgs "hypridle" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      cfg.hypridlePackage
    ];

    # Hyprlock needs Hypridle systemd service to be running to detect idle time
    systemd.user.services.hypridle = {
      description = "Hypridle idle daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      script = lib.getExe cfg.hypridlePackage;
    };

    # Hyprlock needs PAM access to authenticate, else it fallbacks to su
    security.pam.services.hyprlock = {};
  };

  meta.maintainers = with lib.maintainers; [ johnrtitor ];
}
