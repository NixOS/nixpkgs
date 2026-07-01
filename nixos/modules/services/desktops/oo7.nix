{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.oo7;
in
{
  options = {
    services.oo7 = {
      enable = lib.mkEnableOption ''
        oo7, a service providing the Secret Service D-Bus API.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.oo7-server
      pkgs.oo7-portal
      pkgs.oo7-pam
    ];

    services.dbus.packages = [
      pkgs.oo7-server
    ];

    xdg.portal.extraPortals = [ pkgs.oo7-portal ];

    security.pam.services.login.oo7.enable = true;

    security.wrappers.oo7-daemon = {
      owner = "root";
      group = "root";
      capabilities = "cap_ipc_lock=ep";
      source = "${pkgs.oo7-server}/libexec/oo7-daemon";
    };
  };
}
