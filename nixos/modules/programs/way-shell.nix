{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.way-shell;
in
{
  options.programs.way-shell = {
    enable = lib.mkEnableOption "way-shell, a GNOME-like shell for Wayland compositors";
    package = lib.mkPackageOption pkgs "way-shell" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Service dependencies expected by way-shell. It is not enough to simply add packages
    # to systemPackages, because way-shell expects daemons or IPC services to be available
    # for basic functionality.
    networking.networkmanager.enable = true;
    services = {
      upower.enable = true;
      pipewire = {
        enable = true;
        wireplumber.enable = true;
      };
    };
  };
}
