{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.kvmgt;

  kernelPackages = config.boot.kernelPackages;

  vgpuOptions = {
    uuid = mkOption {
      type = with types; listOf str;
      description = "UUID(s) of VGPU device. You can generate one with `libossp_uuid`.";
    };
  };

in {
  options = {
    virtualisation.kvmgt = {
      enable = mkEnableOption ''
        KVMGT (iGVT-g) VGPU support. Allows Qemu/KVM guests to share host's Intel integrated graphics card.
        Currently only one graphical device can be shared. To allow users to access the device without root add them
        to the kvm group: `users.extraUsers.<yourusername>.extraGroups = [ "kvm" ];`
      '';
      # multi GPU support is under the question
      device = mkOption {
        type = types.str;
        default = "0000:00:02.0";
        description = "PCI ID of graphics card. You can figure it with {command}`ls /sys/class/mdev_bus`.";
      };
      vgpus = mkOption {
        default = {};
        type = with types; attrsOf (submodule [ { options = vgpuOptions; } ]);
        description = ''
          Virtual GPUs to be used in Qemu. You can find devices via {command}`ls /sys/bus/pci/devices/*/mdev_supported_types`
          and find info about device via {command}`cat /sys/bus/pci/devices/*/mdev_supported_types/i915-GVTg_V5_4/description`
        '';
        example = {
          i915-GVTg_V5_8.uuid = [ "a297db4a-f4c2-11e6-90f6-d3b88d6c9525" ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = singleton {
      assertion = versionAtLeast kernelPackages.kernel.version "4.16";
      message = "KVMGT is not properly supported for kernels older than 4.16";
    };

    boot.kernelModules = [ "kvmgt" ];
    boot.kernelParams = [ "i915.enable_gvt=1" ];

    services.udev.extraRules = ''
      SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
    '';

    systemd = let
      vgpus = listToAttrs (flatten (mapAttrsToList
        (mdev: opt: map (id: nameValuePair "kvmgt-${id}" { inherit mdev; uuid = id; }) opt.uuid)
        cfg.vgpus));
    in {
      paths = mapAttrs (_: opt:
        {
          description = "KVMGT VGPU ${opt.uuid} path";
          wantedBy = [ "multi-user.target" ];
          pathConfig = {
            PathExists = "/sys/bus/pci/devices/${cfg.device}/mdev_supported_types/${opt.mdev}/create";
          };
        }) vgpus;

      services = mapAttrs (_: opt:
        {
          description = "KVMGT VGPU ${opt.uuid}";
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.runtimeShell} -c 'echo ${opt.uuid} > /sys/bus/pci/devices/${cfg.device}/mdev_supported_types/${opt.mdev}/create'";
            ExecStop = "${pkgs.runtimeShell} -c 'echo 1 > /sys/bus/pci/devices/${cfg.device}/${opt.uuid}/remove'";
          };
        }) vgpus;
    };
  };

  meta.maintainers = with maintainers; [ patryk27 ];
}
