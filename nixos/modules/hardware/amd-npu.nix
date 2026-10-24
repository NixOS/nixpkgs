{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.hardware.amd-npu;
in
{
  options.hardware.amd-npu = {
    enable = mkEnableOption "AMD Ryzen AI NPU (XDNA), the in-kernel amdxdna driver and XRT userspace";
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "amdxdna" ];

    environment.systemPackages = [ pkgs.xrt.xdna ];

    services.udev.extraRules = ''
      KERNEL=="accel*", SUBSYSTEM=="misc", ATTRS{driver}=="amdxdna", GROUP="video", MODE="0660"
    '';

    security.pam.loginLimits = [
      {
        domain = "@video";
        type = "-";
        item = "memlock";
        value = "unlimited";
      }
    ];
  };
}
