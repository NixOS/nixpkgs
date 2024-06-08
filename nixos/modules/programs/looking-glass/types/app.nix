{lib, ...}: {
  options = {
    renderer = lib.mkOption {
      description = "Specify the renderer to use";
      default = "auto";
      type = lib.types.str;
    };

    cursorPollInterval = lib.mkOption {
      description = "How often to check for a cursor update in microseconds";
      default = 1000;
      type = lib.types.ints.positive;
    };

    framePollInterval = lib.mkOption {
      description = "How often to check for a frame update in microseconds";
      default = 1000;
      type = lib.types.ints.positive;
    };

    allowDMA = lib.mkOption {
      description = "Allow DMA transfers if supported";
      default = true;
      type = lib.types.bool;
    };

    shmFile = lib.mkOption {
      description = "Path to the shared memory file or kvmfr device";
      default = "/dev/kvmfr0";
      type = lib.types.str;
    };
  };
}
