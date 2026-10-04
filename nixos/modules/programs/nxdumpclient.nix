{
  lib,
  pkgs,
  config,
  ...
}:

{
  options.programs.nxdumpclient = {
    enable = lib.mkEnableOption "NX Dump Client";
  };

  config = lib.mkIf config.programs.nxdumpclient.enable {
    environment.systemPackages = [ pkgs.nxdumpclient ];
    services.dbus.packages = [ pkgs.nxdumpclient ];
    services.udev.packages = [ pkgs.nxdumpclient ];
  };
}
