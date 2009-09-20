{pkgs, config, ...}:

{
  options = {
    environment.noXlibs = pkgs.lib.mkOption {
      default = false;
      example = true;
      description = "Removing on-by-default X-dependent settings";
    };
  };
  config = pkgs.lib.mkIf config.environment.noXlibs {
    services = {
      sshd = {
        forwardX11 = false;
      };
      dbus.enable = false;
      hal.enable = false;
    };
    fonts = {
      enableCoreFonts = false;
      enableFontConfig = false;
    };
  };
}
