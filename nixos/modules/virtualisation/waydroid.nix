{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.virtualisation.waydroid;
  kCfg = config.lib.kernelConfig;
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
    enable = lib.mkEnableOption "Waydroid";
    package = lib.mkPackageOption pkgs "waydroid" { } // {
      default = if config.networking.nftables.enable then pkgs.waydroid-nftables else pkgs.waydroid;
      defaultText = lib.literalExpression "if config.networking.nftables.enable then pkgs.waydroid-nftables else pkgs.waydroid";
    };
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

    /*
      NOTE: we always enable this flag even if CONFIG_PSI_DEFAULT_DISABLED is not on
      as reading the kernel config is not always possible and on kernels where it's
      already on it will be no-op
    */
    boot.kernelParams = [ "psi=1" ];

    environment.etc."gbinder.d/waydroid.conf".source = waydroidGbinderConf;

    environment.systemPackages = [ cfg.package ];

    networking.firewall.trustedInterfaces = [ "waydroid0" ];

    virtualisation.lxc.enable = true;

    systemd.packages = [ cfg.package ];

    # [Install] sections from systemd.packages aren't applied
    systemd.services.waydroid-container.wantedBy = [ "multi-user.target" ];

    systemd.tmpfiles.rules = [
      "d /var/lib/misc 0755 root root -" # for dnsmasq.leases
    ];

    services.dbus.packages = [ cfg.package ];
  };

}
