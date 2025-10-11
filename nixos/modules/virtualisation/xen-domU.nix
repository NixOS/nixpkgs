{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkPackageOption
    mkIf
    mkMerge
    optionalString
    ;
  inherit (lib.types) nullOr enum;
  inherit (lib.teams.xen) members;

  xen = config.virtualisation.xen;
  cfg = xen.guest;
  isHVM = cfg.type == "hvm";
  isPV = cfg.type == "pv";
  agentOnly = isNull cfg.type;
in

{
  options.virtualisation.xen.guest = {
    enable = mkEnableOption "the Xen Guest Agent daemon, for easier XenStore access inside unprivileged domains";
    package = mkPackageOption pkgs "Xen Guest Agent" { default = "xen-guest-agent"; };
    type = mkOption {
      type = nullOr (enum [
        "pv"
        "hvm"
      ]);
      description = ''
        Whether to set the recommended settings for PV/PVH or HVM guests.

        Both PVH and PV guests should set this setting to `pv`.

        Setting this to `null` will only enable the Xen Guest Agent service.
      '';
      default = null;
      example = "hvm";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
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
    }
    (mkIf (!agentOnly) {
      boot = {
        # PV/PVH guests are booted by the hypervisor, so we don't need a bootloader.
        loader.grub.device = optionalString isPV "nodev";
        # PV/PVH guests don't need a kernel or initrd, as they're provided by Xen.
        kernel.enable = isHVM;
        initrd = {
          enable = isHVM;
          # The kernelModules configuration gets ignored if a kernel is missing.
          kernelModules = [
            "xen-blkfront"
            "xen-tpmfront"
            "xen-kbdfront"
            "xen-fbfront"
            "xen-netfront"
            "xen-pcifront"
            "xen-scsifront"
            "xen-balloon"
            "xen-hcd"
            "xenfs"
          ];
        };
        kernelModules = [
          "9pnet_xen"
          "xen_wdt"
          "drm_xen_front"
          "snd_xen_front"
        ];
      };

      services = {
        # Send syslog messages to the Xen console.
        syslogd.tty = "hvc0";
        # Don't run ntpd, since we should get the correct time from Dom0.
        timesyncd.enable = false;
      };
    })
  ]);
  meta.maintainers = members;
}
