{ config, lib, pkgs, ... }:

let
  cfg = config.virtualisation.waydroid;
  kCfg = config.lib.kernelConfig;
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
    enable = lib.mkEnableOption (lib.mdDoc "Waydroid");
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.singleton {
      assertion = lib.versionAtLeast (lib.getVersion config.boot.kernelPackages.kernel) "4.18";
      message = "Waydroid needs user namespace support to work properly";
    };

    system.requiredKernelConfig = [
      (kCfg.isEnabled "ANDROID_BINDER_IPC")
      (kCfg.isEnabled "ANDROID_BINDERFS")
      (kCfg.isEnabled "MEMFD_CREATE")
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

      serviceConfig = {
        ExecStart = "${pkgs.waydroid}/bin/waydroid -w container start";
        ExecStop = "${pkgs.waydroid}/bin/waydroid container stop";
        ExecStopPost = "${pkgs.waydroid}/bin/waydroid session stop";
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/misc 0755 root root -" # for dnsmasq.leases
    ];
  };

}
