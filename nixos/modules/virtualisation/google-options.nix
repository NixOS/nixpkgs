{ lib, ... }:

with lib;

{
  options = {
    gcp.computeImage.size = mkOption {
      type = types.int;
      default = 100*1024;
      description = ''
        The size of the disk image built by
        <code>system.build.googleComputeImage</code>.
      '';
    };
  };
}
