{lib, ...}: {
  options = {
    mipmap = lib.mkOption {
      description = "Enable mipmapping";
      default = true;
      type = lib.types.bool;
    };

    vsync = lib.mkOption {
      description = "Enable vsync";
      default = false;
      type = lib.types.bool;
    };

    preventBuffer = lib.mkOption {
      description = "Prevent the driver from buffering frames";
      default = true;
      type = lib.types.bool;
    };

    amdPinnedMem = lib.mkOption {
      description = "Use GL_AMD_pinned_memory if it is available";
      default = true;
      type = lib.types.bool;
    };
  };
}
