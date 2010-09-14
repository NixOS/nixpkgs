# Xen hypervisor support.

{ config, pkgs, ... }:

with pkgs.lib;

let cfg = config.virtualisation.xen; in

{
  ###### interface

  options = {

    virtualisation.xen.enable = 
      mkOption {
        default = false;
        description =
          ''
            Setting this option enables the Xen hypervisor, a
            virtualisation technology that allows multiple virtual
            machines, known as <emphasis>domains</emphasis>, to run
            concurrently on the physical machine.  NixOS runs as the
            privileged <emphasis>Domain 0</emphasis>.  This option
            requires a reboot to take effect.
          '';
      };

    virtualisation.xen.bootParams = 
      mkOption {
        default = "";
        description =
          ''
            Parameters passed to the Xen hypervisor at boot time.
          '';
      };

    virtualisation.xen.domain0MemorySize = 
      mkOption {
        default = 0;
        example = 512;
        description =
          ''
            Amount of memory (in MiB) allocated to Domain 0 on boot.
            If set to 0, all memory is assigned to Domain 0.
          '';
      };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.xen ];

    # Domain 0 requires a pvops-enabled kernel.
    boot.kernelPackages = pkgs.linuxPackages_2_6_32_xen;

    boot.kernelModules = [ "xen_evtchn" "xen_gntdev" ];

    # The radeonfb kernel module causes the screen to go black as soon
    # as it's loaded, so don't load it.
    boot.blacklistedKernelModules = [ "radeonfb" ];

    virtualisation.xen.bootParams = 
      [ "loglvl=all" "guest_loglvl=all" ] ++
      optional (cfg.domain0MemorySize != 0) "dom0_mem=${toString cfg.domain0MemorySize}M";

    system.extraSystemBuilderCmds =
      ''
        ln -s ${pkgs.xen}/boot/xen.gz $out/xen.gz
        echo "${toString cfg.bootParams}" > $out/xen-params
      '';

    # Mount the /proc/xen pseudo-filesystem.
    system.activationScripts.xen =
      ''
        if [ -d /proc/xen ]; then
            ${pkgs.sysvtools}/bin/mountpoint -q /proc/xen || \
                ${pkgs.utillinux}/bin/mount -t xenfs none /proc/xen
        fi
      '';

    jobs.xend =
      { description = "Xen control daemon";

        startOn = "stopped udevtrigger";

        path = 
          [ pkgs.bridge_utils pkgs.gawk pkgs.iproute pkgs.nettools 
            pkgs.utillinux pkgs.bash pkgs.xen pkgs.pciutils pkgs.procps
          ];

        preStart = "${pkgs.xen}/sbin/xend start";

        postStop = "${pkgs.xen}/sbin/xend stop";
      };

  };

}
