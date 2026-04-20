{
  config,
  lib,
  ...
}:

let
  cfg = config.boot.ramoops;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.boot.ramoops = {
    enable = mkEnableOption "dumping kernel panics to RAM";

    memorySize = mkOption {
      description = ''
        Size of reserved memory area for ramoops.
      '';
      default = "4M";
      example = "8M";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [ "ramoops" ];
    boot.kernelParams = [
      # reserve_mem will not always return the same memory area, depending on hardware and kernel
      # We should also allow static allocation in the future
      "reserve_mem=${cfg.memorySize}:4096:oops"
      "ramoops.mem_name=oops"
    ];

    boot.kernel.sysctl = {
      "kernel.panic" = -1;
      "kernel.panic_on_oops" = 1;
      "kernel.hardlockup_panic" = 1;
      "kernel.softlockup_panic" = 1;
    };
  };
}
