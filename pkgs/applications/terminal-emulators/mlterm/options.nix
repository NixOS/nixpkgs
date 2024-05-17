{
  lib,
  config,
  stdenv,
  ...
}:

{
  options = {
    gui = {
      xlib = lib.mkOption { default = config.x11; };
      # From some reason, upstream's ./configure script disables compilation of the
      # external tool `mlconfig` if `config.gui.fb == true`. This behavior is not
      # documentd in `./configure --help`, and it is reported here:
      # https://github.com/arakiken/mlterm/issues/73
      fb = lib.mkOption { default = false; };
      quartz = lib.mkOption { default = stdenv.isDarwin; };
      wayland = lib.mkOption { default = stdenv.isLinux; };
      sdl2 = lib.mkOption { default = true; };
    };

    # Whether to enable the X window system
    x11 = lib.mkOption { default = stdenv.isLinux; };

    typeEngines = {
      # List of typing engines, the default list enables compiling all of the
      # available ones, as recorded on release 3.9.3
        xcore = lib.mkOption { default = false; }; # Considered legacy
        xft = lib.mkOption { default = config.x11; };
        cairo = lib.mkOption { default = true; };
    };

    desktopBinary = lib.mkOption {
      default =
        # Configure the Exec directive in the generated .desktop file
        if config.gui.xlib then
          "mlterm"
        else if config.gui.wayland then
          "mlterm-wl"
        else if config.gui.sdl2 then
          "mlterm-sdl2"
        else
          throw "mlterm: couldn't figure out what desktopBinary to use.";
    };
  };
}
