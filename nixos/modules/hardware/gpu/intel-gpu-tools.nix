{ lib, pkgs, ... }:

with lib;

{
  options = {
    hardware.intel-gpu-tools = {
      enable = mkEnableOption "a perfmon wrapper for intel-gpu-tools";
    };
  };

  config = mkIf cfg.enable {
    security.wrappers.intel_gpu_top = {
      source = "${pkgs.intel-gpu-tools}/bin/intel_gpu_top";
      capabilities = "cap_perfmon+ep";
      owner = "root";
      group = "root";
    };
  };

  meta = {
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
