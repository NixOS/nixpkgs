{
  lib,
  config,
  stdenv,
  ...
}:

let
  # For prototyping. In reality you may want to declare options manually
  quickConvert = lib.mapAttrs (n: v: lib.mkOption { default = v; });
in

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

    # Most of the input methods and other build features are enabled by default,
    # the following attribute set can be used to disable some of them. It's parsed
    # when we set `configureFlags`. If you find other configure Flags that require
    # dependencies, it'd be nice to make that contribution here.
    features = quickConvert {
      uim = !stdenv.isDarwin;
      ibus = !stdenv.isDarwin;
      fcitx = !stdenv.isDarwin;
      m17n = !stdenv.isDarwin;
      ssh2 = true;
      bidi = true;
      # Open Type layout support, (substituting glyphs with opentype fonts)
      otl = true;
    };

    # List of external tools to create, this default list includes all default
    # tools, as recorded on release 3.9.3.
    tools = quickConvert {
      mlclient = true;
      mlconfig = true;
      mlcc = true;
      mlterm-menu = true;
      # Note that according to upstream's ./configure script, to disable
      # mlimgloader you have to disable _all_ tools. See:
      # https://github.com/arakiken/mlterm/issues/69
      mlimgloader = true;
      registobmp = true;
      mlfc = true;
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
