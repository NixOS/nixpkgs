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

in {

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
      (isEnabled "ASHMEM")
    ];

    environment.etc."gbinder.d/waydroid.conf".source = waydroidGbinderConf;

    environment.systemPackages = with pkgs; [ waydroid ];

    networking.firewall.trustedInterfaces = [ "waydroid0" ];

    virtualisation.lxc.enable = true;

    systemd.services.waydroid-container = {
      description = "Waydroid Container";

      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [ getent iptables iproute kmod nftables util-linux which ];

      unitConfig = {
        ConditionPathExists = "/var/lib/waydroid/lxc/waydroid";
      };

      serviceConfig = {
        ExecStart = "${pkgs.waydroid}/bin/waydroid container start";
        ExecStop = "${pkgs.waydroid}/bin/waydroid container stop";
        ExecStopPost = "${pkgs.waydroid}/bin/waydroid session stop";
      };
    };
  };

}
