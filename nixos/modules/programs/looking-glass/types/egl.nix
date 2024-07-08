{lib, ...}: {
  options = {
    vsync = lib.mkOption {
      description = "Enable vsync";
      default = false;
      type = lib.types.bool;
    };

    doubleBuffer = lib.mkOption {
      description = "Enable double buffering";
      default = false;
      type = lib.types.bool;
    };

    multiSample = lib.mkOption {
      description = "Enable multisampling";
      default = true;
      type = lib.types.bool;
    };

    nvGainMax = lib.mkOption {
      description = "The maximum night vision gain";
      default = 1;
      type = lib.types.int;
    };

    nvGain = lib.mkOption {
      description = "The initial night vision gain at startup";
      default = 0;
      type = lib.types.int;
    };

    cbMode = lib.mkOption {
      description = "Color Blind Mode (0 = Off, 1 = Protanope, 2 = Deuteranope, 3 = Tritanope)";
      default = 0;
      type = lib.types.addCheck lib.types.int (x: x >= 0 && x <= 3);
    };

    scale = lib.mkOption {
      description = "Set the scale algorithm (0 = auto, 1 = nearest, 2 = linear)";
      default = 0;
      type = lib.types.addCheck lib.types.int (x: x >= 0 && x <= 2);
    };

    debug = lib.mkOption {
      description = "Enable debug output";
      default = false;
      type = lib.types.bool;
    };

    noBufferAge = lib.mkOption {
      description = "Disable partial rendering based on buffer age";
      default = false;
      type = lib.types.bool;
    };

    noSwapDamage = lib.mkOption {
      description = "Disable swapping with damage";
      default = false;
      type = lib.types.bool;
    };

    scalePointer = lib.mkOption {
      description = "Keep the pointer size 1:1 when downscaling";
      default = true;
      type = lib.types.bool;
    };
  };
}
