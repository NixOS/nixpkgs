{lib, ...}: {
  options = {
    enable = lib.mkOption {
      description = "Enable the built-in SPICE client for input and/or clipboard support";
      default = true;
      type = lib.types.bool;
    };

    host = lib.mkOption {
      description = "The SPICE server host or UNIX socket";
      default = "127.0.0.1";
      type = lib.types.str;
    };

    port = lib.mkOption {
      description = "The SPICE server port (0 = unix socket)";
      default = 5900;
      type = lib.types.port;
    };

    input = lib.mkOption {
      description = "Use SPICE to send keyboard and mouse input events to the guest";
      default = true;
      type = lib.types.bool;
    };

    clipboard = lib.mkOption {
      description = "Use SPICE to synchronize the clipboard contents with the guest";
      default = true;
      type = lib.types.bool;
    };

    clipboardToVM = lib.mkOption {
      description = "Allow the clipboard to be synchronized TO the VM";
      default = true;
      type = lib.types.bool;
    };

    clipboardToLocal = lib.mkOption {
      description = "Allow the clipbaord to be synchronized FROM the VM";
      default = true;
      type = lib.types.bool;
    };

    audio = lib.mkOption {
      description = "Enable SPICE audio support";
      default = true;
      type = lib.types.bool;
    };

    scaleCursor = lib.mkOption {
      description = "Scale cursor input position to screen size when up/down scaled";
      default = true;
      type = lib.types.bool;
    };

    captureOnStart = lib.mkOption {
      description = "Capture mouse and keybaord on start";
      default = false;
      type = lib.types.bool;
    };

    alwaysShowCursor = lib.mkOption {
      description = "Always show host cursor";
      default = false;
      type = lib.types.bool;
    };

    showCursorDot = lib.mkOption {
      description = "Use a 'dot' cursor when the window does not have focus";
      default = true;
      type = lib.types.bool;
    };
  };
}
