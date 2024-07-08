{lib, ...}: {
  options = {
    warpSupport = lib.mkOption {
      description = "Enable cursor warping";
      default = true;
      type = lib.types.bool;
    };

    fractionScale = lib.mkOption {
      description = "Enable fractional scale";
      default = true;
      type = lib.types.bool;
    };
  };
}
