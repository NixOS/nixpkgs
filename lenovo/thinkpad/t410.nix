{ config, pkgs, ... }:

{
  imports = [ ./general-intel.nix ];

  boot = {
    kernelParams = [
      # Kernel GPU Savings Options (NOTE i915 chipset only)
      "drm.debug=0" "drm.vblankoffdelay=1" "i915.semaphores=1" "i915.modeset=1"
      "i915.use_mmio_flip=1" "i915.powersave=1" "i915.enable_ips=1"
      "i915.disable_power_well=1" "i915.enable_hangcheck=1"
      "i915.enable_cmd_parser=1" "i915.fastboot=0" "i915.enable_ppgtt=1"
      "i915.reset=0" "i915.lvds_use_ssc=0" "i915.enable_psr=0" "vblank_mode=0"
      "i915.i915_enable_rc6=1"
    ];
    blacklistedKernelModules = [
      # Kernel GPU Savings Options (NOTE i915 chipset only)
      "sierra_net" "cdc_mbim" "cdc_ncm" "btusb"
    ];
  };

  hardware.cpu.intel.updateMicrocode = true;

  systemd.services.tune-powermanagement = {
    description = "Tune Powermanagement";
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    wantedBy = [ "multi-user.target" ];
    unitConfig.RequiresMountsFor = "/sys";
    script = ''
      echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs'
      echo '1' > '/sys/module/snd_hda_intel/parameters/power_save'
      echo 'auto' > '/sys/bus/i2c/devices/i2c-0/device/power/control'
      echo 'auto' > '/sys/bus/i2c/devices/i2c-1/device/power/control'
      echo 'auto' > '/sys/bus/i2c/devices/i2c-2/device/power/control'
      echo 'auto' > '/sys/bus/i2c/devices/i2c-3/device/power/control'
      echo 'auto' > '/sys/bus/i2c/devices/i2c-4/device/power/control'
      echo 'auto' > '/sys/bus/i2c/devices/i2c-5/device/power/control'
      echo 'auto' > '/sys/bus/i2c/devices/i2c-6/device/power/control'
      echo 'auto' > '/sys/bus/i2c/devices/i2c-7/device/power/control'
      echo 'auto' > '/sys/bus/i2c/devices/i2c-8/device/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:00.0/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:02.0/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:16.0/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:16.3/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:19.0/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:1a.0/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:1b.0/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.0/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.1/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.3/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.4/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:1d.0/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:1e.0/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.0/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.2/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.3/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.6/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:03:00.0/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:0d:00.0/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:0d:00.1/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:ff:00.0/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:ff:00.1/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:ff:02.0/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:ff:02.1/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:ff:02.2/power/control'
      echo 'auto' > '/sys/bus/pci/devices/0000:ff:02.3/power/control'
      echo 'auto' > '/sys/bus/usb/devices/1-1.3/power/control'
      echo 'min_power' > '/sys/class/scsi_host/host0/link_power_management_policy'
      echo 'min_power' > '/sys/class/scsi_host/host1/link_power_management_policy'
      echo 'min_power' > '/sys/class/scsi_host/host2/link_power_management_policy'
      echo 'min_power' > '/sys/class/scsi_host/host3/link_power_management_policy'
      echo 'min_power' > '/sys/class/scsi_host/host4/link_power_management_policy'
      echo 'min_power' > '/sys/class/scsi_host/host5/link_power_management_policy'
      /run/current-system/sw/bin/rmmod e1000e || true
    '';
    # ${pkgs.ethtool}/bin/ethtool -s enp0s25 wol d || true
  };

}
