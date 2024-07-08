{config, lib, ...}: {
  options = {
    app = lib.mkOption {
      description = "Application-wide configuration";
      default = {};
      type = lib.types.submodule ./app.nix;
    };

    win = lib.mkOption {
      description = "Window configuration";
      default = {};
      type = lib.types.submodule ./win.nix;
    };

    input = lib.mkOption {
      description = "Input configuration";
      default = {};
      type = lib.types.submodule ./input.nix;
    };

    spice = lib.mkOption {
      description = "Spice agent configuration";
      default = {};
      type = lib.types.submodule ./spice.nix;
    };

    audio = lib.mkOption {
      description = "Audio configuration";
      default = {};
      type = lib.types.submodule ./audio.nix;
    };

    egl = lib.mkOption {
      description = "EGL configuration";
      default = {};
      type = lib.types.submodule ./egl.nix;
    };

    opengl = lib.mkOption {
      description = "OpenGL configuration";
      default = {};
      type = lib.types.submodule ./opengl.nix;
    };

    wayland = lib.mkOption {
      description = "Wayland configuration";
      default = {};
      type = lib.types.submodule ./wayland.nix;
    };
  };
}
