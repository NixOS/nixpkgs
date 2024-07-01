{lib, ...}: {
  options = {
    periodSize = lib.mkOption {
      description = "Requested audio device period size in samples";
      default = 2048;
      type = lib.types.ints.positive;
    };

    bufferLatency = lib.mkOption {
      description = "Additional buffer latency in milliseconds";
      default = 13;
      type = lib.types.ints.positive;
    };

    micDefault = lib.mkOption {
      description = "Default action when an application opens the microphone";
      default = "prompt";
      type = lib.types.enum ["prompt" "allow" "deny"];
    };

    micShowIndicator = lib.mkOption {
      description = "Display microphone usage indicator";
      default = true;
      type = lib.types.bool;
    };
  };
}
