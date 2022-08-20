{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.waydroid;
  kernelPackages = config.boot.kernelPackages;
  waydroidGbinderConf = pkgs.writeText "waydroid.conf" ''
    [Protocol]
    /dev/binder = aidl2
    /dev/vndbinder = aidl2
    /dev/hwbinder = hidl

    [ServiceManager]
    /dev/binder = aidl2
    /dev/vndbinder = aidl2
    /dev/hwbinder = hidl
  '';

in
{

  options.virtualisation.waydroid = {
    enable = mkEnableOption "Waydroid";
  };

  config = mkIf cfg.enable {
    assertions = singleton {
      assertion = versionAtLeast (getVersion config.boot.kernelPackages.kernel) "4.18";
      message = "Waydroid needs user namespace support to work properly";
    };

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isEnabled "ANDROID_BINDER_IPC")
      (isEnabled "ANDROID_BINDERFS")
      (isEnabled "ASHMEM") # FIXME Needs memfd support instead on Linux 5.18 and waydroid 1.2.1
    ];

    /* NOTE: we always enable this flag even if CONFIG_PSI_DEFAULT_DISABLED is not on
      as reading the kernel config is not always possible and on kernels where it's
      already on it will be no-op
    */
    boot.kernelParams = [ "psi=1" ];

    environment.etc."gbinder.d/waydroid.conf".source = waydroidGbinderConf;

    environment.systemPackages = with pkgs; [ waydroid ];

    networking.firewall.trustedInterfaces = [ "waydroid0" ];

    virtualisation.lxc.enable = true;

    systemd.services.waydroid-container = {
      description = "Waydroid Container";

      wantedBy = [ "multi-user.target" ];

      unitConfig = {
        ConditionPathExists = "/var/lib/waydroid/lxc/waydroid";
      };

      serviceConfig = {
        ExecStart = "${pkgs.waydroid}/bin/waydroid container start";
        ExecStop = "${pkgs.waydroid}/bin/waydroid container stop";
        ExecStopPost = "${pkgs.waydroid}/bin/waydroid session stop";
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/misc 0755 root root -" # for dnsmasq.leases
    ];
  };

}
