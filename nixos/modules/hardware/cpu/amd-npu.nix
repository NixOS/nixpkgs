{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.cpu.amd.npu;
in
{
  options = {
    hardware.cpu.amd.npu = {
      enable = lib.mkEnableOption "AMD NPU support";

      package = lib.mkPackageOption pkgs [ "xrt" "xdna" ] { };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.14";
        message = "hardware.cpu.amd.npu requires kernel 6.14 or later for the in-tree amdxdna driver.";
      }
    ];

    boot.kernelModules = [ "amdxdna" ];

    environment.systemPackages = [ cfg.package ];

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
