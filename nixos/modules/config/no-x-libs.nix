{ config, pkgs, ... }:

with pkgs.lib;

{
  options = {
    environment.noXlibs = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Switch off the options in the default configuration that require X libraries.
        Currently this includes: ssh X11 forwarding, dbus, fonts.enableCoreFonts,
        fonts.enableFontConfig
      '';
    };
  };

  config = mkIf config.environment.noXlibs {
    programs.ssh.setXAuthLocation = false;
    fonts = {
      enableCoreFonts = false;
      enableFontConfig = false;
    };
  };
}
