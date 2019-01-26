{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.kvmgt;
  kernelPackages = config.boot.kernelPackages;
  vgpuOptions = {
    uuid = mkOption {
      type = types.string;
      description = "UUID of VGPU device. You can generate one with <package>libossp_uuid</package>.";
    };
  };
in {
  options = {
    virtualisation.kvmgt = {
      enable = mkEnableOption ''
        KVMGT (iGVT-g) VGPU support. Allows Qemu/KVM guests to share host's Intel integrated graphics card.
        Currently only one graphical device can be shared
      '';
      # multi GPU support is under the question
      device = mkOption {
        type = types.string;
        default = "0000:00:02.0";
        description = "PCI ID of graphics card. You can figure it with <command>ls /sys/class/mdev_bus</command>.";
      };
      vgpus = mkOption {
        default = {};
        type = with types; attrsOf (submodule [ { options = vgpuOptions; } ]);
        description = ''
          Virtual GPUs to be used in Qemu. You can find devices via <command>ls /sys/bus/pci/devices/*/mdev_supported_types</command>
          and find info about device via <command>cat /sys/bus/pci/devices/*/mdev_supported_types/i915-GVTg_V5_4/description</command>
        '';
        example = {
          "i915-GVTg_V5_8" = {
            uuid = "a297db4a-f4c2-11e6-90f6-d3b88d6c9525";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = singleton {
      assertion = versionAtLeast kernelPackages.kernel.version "4.16";
      message = "KVMGT is not properly supported for kernels older than 4.16";
    };
    boot.kernelParams = [ "i915.enable_gvt=1" ];
    systemd.services = mapAttrs' (name: value:
      nameValuePair "kvmgt-${name}" {
        description = "KVMGT VGPU ${name}";
        serviceConfig = {
          Type = "forking";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = 5;
          ExecStart = "${pkgs.runtimeShell} -c 'echo ${value.uuid} > /sys/bus/pci/devices/${cfg.device}/mdev_supported_types/${name}/create'";
          ExecStop = "${pkgs.runtimeShell} -c 'echo 1 > /sys/bus/pci/devices/${cfg.device}/${value.uuid}/remove'";
        };
        unitConfig = {
          StartLimitBurst = 5;
          StartLimitIntervalSec = 30;
        };
        wantedBy = [ "multi-user.target" ];
      }
    ) cfg.vgpus;
  };

  meta.maintainers = with maintainers; [ gnidorah ];
}
