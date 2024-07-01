{lib, ...}: {
  options = {
    title = lib.mkOption {
      description = "Window Title";
      default = "Looking Glass (client)";
      type = lib.types.str;
    };

    position = lib.mkOption {
      description = "Initial window position at startup";
      default = "center";
      type = lib.types.str;
    };

    size = lib.mkOption {
      description = "Initial window size at startup";
      default = "1024x768";
      type = lib.types.str;
    };

    autoResize = lib.mkOption {
      description = "Auto resize the window to the guest";
      default = false;
      type = lib.types.bool;
    };

    allowResize = lib.mkOption {
      description = "Allow the window to be resized manually";
      default = true;
      type = lib.types.bool;
    };

    keepAspect = lib.mkOption {
      description = "Maintain correct aspect ratio";
      default = true;
      type = lib.types.bool;
    };

    forceAspect = lib.mkOption {
      description = "Force the window to maintain the aspect ratio";
      default = true;
      type = lib.types.bool;
    };

    dontUpscale = lib.mkOption {
      description = "Never try to upscale the window";
      default = false;
      type = lib.types.bool;
    };

    intUpscale = lib.mkOption {
      description = "Allow only integer upscaling";
      default = false;
      type = lib.types.bool;
    };

    shrinkOnUpscale = lib.mkOption {
      description = "Limit the window dimensions when dontUpscale is enabled";
      default = false;
      type = lib.types.bool;
    };

    borderless = lib.mkOption {
      description = "Borderless mode";
      default = false;
      type = lib.types.bool;
    };

    fullScreen = lib.mkOption {
      description = "Launch in fullscreen borderless mode";
      default = false;
      type = lib.types.bool;
    };

    maximize = lib.mkOption {
      description = "Launch window maximized";
      default = false;
      type = lib.types.bool;
    };

    minimizeOnFocusLoss = lib.mkOption {
      description = "Minimize window on focus loss";
      default = false;
      type = lib.types.bool;
    };

    fpsMin = lib.mkOption {
      description = "Frame rate minimum (0 = disabled - not recommended, -1 = auto-detect)";
      default = -1;
      type = lib.types.addCheck lib.types.int (x: x == -1 || x >= 0);
    };

    ignoreQuit = lib.mkOption {
      description = "Ignore requests to quit (i.e. Alt+F4)";
      default = false;
      type = lib.types.bool;
    };

    noScreensaver = lib.mkOption {
      description = "Prevent the screensaver from starting";
      default = false;
      type = lib.types.bool;
    };

    autoScreensaver = lib.mkOption {
      description = "Prevent the screensaver from starting when the guest requests it";
      default = false;
      type = lib.types.bool;
    };

    alerts = lib.mkOption {
      description = "Show on screen alert messages";
      default = true;
      type = lib.types.bool;
    };

    quickSplash = lib.mkOption {
      description = "Skip fading out the splash screen when a connection is established";
      default = false;
      type = lib.types.bool;
    };

    overlayDimsDesktop = lib.mkOption {
      description = "Dim the desktop when in interactive overlay mode";
      default = true;
      type = lib.types.bool;
    };

    rotate = lib.mkOption {
      description = "Rotate the displayed image (0, 90, 180, 270)";
      default = 0;
      type = lib.types.int;
    };

    uiFont = lib.mkOption {
      description = "The font to use when rendering on-screen UI";
      default = "DejaVu Sans Mono";
      type = lib.types.str;
    };

    uiSize = lib.mkOption {
      description = "The font size to use when rendering on-screen UI";
      default = 14;
      type = lib.types.ints.positive;
    };

    jitRender = lib.mkOption {
      description = "Enable just-in-time rendering";
      default = false;
      type = lib.types.bool;
    };

    showFPS = lib.mkOption {
      description = "Enable the FPS and UPS display";
      default = false;
      type = lib.types.bool;
    };
  };
}
