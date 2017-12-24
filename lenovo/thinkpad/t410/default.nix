{ config, lib, pkgs, ... }:

{
  imports = [ ../. ];

  boot = {
    kernelParams = [
      "drm.debug=0"
      "drm.vblankoffdelay=1"
      "i915.semaphores=1"
      "i915.modeset=1"
      "i915.use_mmio_flip=1"
      "i915.powersave=1"
      "i915.enable_ips=1"
      "i915.disable_power_well=1"
      "i915.enable_hangcheck=1"
      "i915.enable_cmd_parser=1"
      "i915.fastboot=0"
      "i915.enable_ppgtt=1"
      "i915.reset=0"
      "i915.lvds_use_ssc=0"
      "i915.enable_psr=0"
      "vblank_mode=0"
      "i915.i915_enable_rc6=1"
    ];
    blacklistedKernelModules = [
      "sierra_net" "cdc_mbim" "cdc_ncm" "btusb"
    ];
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

  services.xserver.videoDrivers = [ "intel" ];
}
