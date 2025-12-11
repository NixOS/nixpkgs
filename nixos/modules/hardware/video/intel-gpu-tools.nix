{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.intel-gpu-tools;
in
{
  options = {
    hardware.intel-gpu-tools = {
      enable = lib.mkEnableOption "a setcap wrapper for intel-gpu-tools";
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.intel_gpu_top = {
      owner = "root";
      group = "root";
      source = "${pkgs.intel-gpu-tools}/bin/intel_gpu_top";
      capabilities = "cap_perfmon+ep";
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ kira-bruneau ];
  };
}
