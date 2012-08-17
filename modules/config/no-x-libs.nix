{pkgs, config, ...}:

{
  options = {
    environment.noXlibs = pkgs.lib.mkOption {
      default = false;
      example = true;
      description = ''
        Switch off the options in the default configuration that require X libraries.
        Currently this includes: ssh X11 forwarding, dbus, fonts.enableCoreFonts,
        fonts.enableFontConfig
      '';
    };
  };
  config = pkgs.lib.mkIf config.environment.noXlibs {
    programs.ssh.setXAuthLocation = false;
    services = {
      dbus.enable = false;
    };
    fonts = {
      enableCoreFonts = false;
      enableFontConfig = false;
    };
  };
}
