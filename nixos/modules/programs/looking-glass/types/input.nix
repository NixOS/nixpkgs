{lib, ...}: {
  options = {
    grabKeyboard = lib.mkOption {
      description = "Grab the keybaord in capture mode";
      default = true;
      type = lib.types.bool;
    };

    grabKeyboardOnFocus = lib.mkOption {
      description = "Grab the keyboard when focused";
      default = false;
      type = lib.types.bool;
    };

    releaseKeysOnFocusLoss = lib.mkOption {
      description = "On focus loss, send key up events to guest for all held keys";
      default = true;
      type = lib.types.bool;
    };

    escapeKey = lib.mkOption {
      description = "Specify the escape/menu key to use";
      default = "KEY_SCROLLLOCK";
      type = import ./keys.nix {
        inherit lib;
      };
    };

    ignoreWindowsKeys = lib.mkOption {
      description = "Do not pass events for the windows keys to the guest";
      default = false;
      type = lib.types.bool;
    };

    hideCursor = lib.mkOption {
      description = "Hide the local mouse cursor";
      default = true;
      type = lib.types.bool;
    };

    mouseSens = lib.mkOption {
      description = "Initial mouse sensitivity when in capture mode (-9 to 9)";
      default = 0;
      type = lib.types.addCheck lib.types.int (x: x >= -9 && x <= 9);
    };

    mouseSmoothing = lib.mkOption {
      description = "Apply simple mouse smoothing when rawMouse is not in use";
      default = true;
      type = lib.types.bool;
    };

    rawMouse = lib.mkOption {
      description = "Use RAW mouse input when in capture mode (good for gaming)";
      default = false;
      type = lib.types.bool;
    };

    mouseRedraw = lib.mkOption {
      description = "Mouse movements trigger redraws (ignore FPS minimum)";
      default = true;
      type = lib.types.bool;
    };

    autoCapture = lib.mkOption {
      description = "Try to keep the mouse captured when needed";
      default = false;
      type = lib.types.bool;
    };

    captureOnly = lib.mkOption {
      description = "Only enable input via SPICE if in capture mode";
      default = false;
      type = lib.types.bool;
    };

    helpMenuDelay = lib.mkOption {
      description = "Show help menu after holding down the escape key for this many milliseconds";
      default = 200;
      type = lib.types.ints.positive;
    };
  };
}
