{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkPackageOption;
  inherit (lib.teams.xen) members;

  xen = config.virtualisation.xen;
  cfg = xen.guest;
in

{
  options.virtualisation.xen.guest = {
    enable = mkEnableOption "the Xen Guest Agent daemon, for easier XenStore access inside unprivileged domains";
    package = mkPackageOption pkgs "Xen Guest Agent" { default = "xen-guest-agent"; };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !xen.enable;
        message = "The Xen domU module cannot be enabled in a Xen dom0.";
      }
      {
        assertion = !config.services.xe-guest-utilities.enable;
        message = "The XenServer guest utilities cannot be enabled alongside the Xen Guest Agent.";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    systemd = {
      packages = [ cfg.package ];
      services.xen-guest-agent.wantedBy = [ "multi-user.target" ];
    };

    boot = {
      kernelParams = [ "console=hvc0" ];
      kernelModules = [
        "9pnet_xen"
        "xen_wdt"
        "drm_xen_front"
        "snd_xen_front"
      ];
      initrd.kernelModules = [
        "xen_blkfront"
        "xen_tpmfront"
        "xen_kbdfront"
        "xen_fbfront"
        "xen_netfront"
        "xen_pcifront"
        "xen_scsifront"
        "xen_hcd"
        "xenfs"
      ];
    };
  };
  meta.maintainers = members;
}
