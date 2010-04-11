{pkgs, config, ...}:

{
  options = {
    environment.noXlibs = pkgs.lib.mkOption {
      default = false;
      example = true;
      description = ''
        Switch off the options in the default configuration that require X libraries.
	Currently this includes: openssh.forwardX11, dbus, hal, fonts.enableCoreFonts,
	fonts.enableFontConfig
      '';
    };
  };
  config = pkgs.lib.mkIf config.environment.noXlibs {
    services = {
      openssh = {
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
