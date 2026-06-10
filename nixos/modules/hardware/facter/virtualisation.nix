{
  lib,
  config,
  options,
  ...
}:
let
  facterLib = import ./lib.nix lib;
  inherit (config.hardware.facter) report;
  cfg = config.hardware.facter.detected.virtualisation;
  hasCPUFeature =
    feature:
    lib.any (
      {
        features ? [ ],
        ...
      }:
      lib.elem feature features
    ) (report.hardware.cpu or [ ]);
  kvmKernelModules =
    lib.optionals (hasCPUFeature "vmx") [ "kvm-intel" ]
    ++ lib.optionals (hasCPUFeature "svm") [ "kvm-amd" ];
  qemuInitrdKernelModules = lib.optionals cfg.qemu.enable [
    "virtio_balloon"
    "virtio_console"
    "virtio_rng"
    "virtio_gpu"
  ];
  qemuAvailableKernelModules =
    lib.optionals cfg.qemu.enable [
      "virtio_net"
      "virtio_pci"
      "virtio_mmio"
      "virtio_blk"
      "9p"
      "9pnet_virtio"
    ]
    ++ lib.optionals cfg.virtio_scsi.enable [
      "virtio_scsi"
    ];
in
{
  options.hardware.facter.detected.virtualisation = {
    virtio_scsi.enable = lib.mkEnableOption "Enable the Facter Virtualisation Virtio SCSI module" // {
      default = lib.any (
        { vendor, device, ... }:
        # vendor (0x1af4) Red Hat, Inc.
        (vendor.value or 0) == 6900
        &&
          # device (0x1004, 0x1048) Virtio SCSI
          (lib.elem (device.value or 0) [
            4100
            4168
          ])
      ) (report.hardware.scsi or [ ]);
      defaultText = "hardware dependent";
    };
    oracle.enable = lib.mkEnableOption "Enable the Facter Virtualisation Oracle module" // {
      default = report.virtualisation or null == "oracle";
      defaultText = "environment dependent";
    };
    parallels.enable = lib.mkEnableOption "Enable the Facter Virtualisation Parallels module" // {
      default = report.virtualisation or null == "parallels";
      defaultText = "environment dependent";
    };
    qemu.enable = lib.mkEnableOption "Enable the Facter Virtualisation Qemu module" // {
      default = builtins.elem (report.virtualisation or null) [
        "qemu"
        "kvm"
        "bochs"
      ];
      defaultText = "environment dependent";
    };
    hyperv.enable = lib.mkEnableOption "Enable the Facter Virtualisation Hyper-V module" // {
      default = report.virtualisation or null == "microsoft";
      defaultText = "environment dependent";
    };
    # no virtualisation detected
    none.enable = lib.mkEnableOption "Enable the Facter Virtualisation None module" // {
      default = report.virtualisation or null == "none";
      defaultText = "environment dependent";
    };
  };

  config = lib.mkIf config.hardware.facter.enable (
    lib.mkMerge [
      {
        # KVM support
        boot.kernelModules = kvmKernelModules;

        # virtio & qemu
        boot.initrd = {
          kernelModules = qemuInitrdKernelModules;
          availableKernelModules = qemuAvailableKernelModules;
        };

        virtualisation = {
          # oracle
          virtualbox.guest.enable = lib.mkIf cfg.oracle.enable (lib.mkDefault true);
          # hyper-v
          hypervGuest.enable = lib.mkIf cfg.hyperv.enable (lib.mkDefault true);
        };

        # parallels
        hardware.parallels.enable = lib.mkIf cfg.parallels.enable (lib.mkDefault true);
        nixpkgs.config = lib.mkIf (!options.nixpkgs.pkgs.isDefined && cfg.parallels.enable) {
          allowUnfreePackages = [ "prl-tools" ];
        };
      }

      (facterLib.mkFacterAssignment {
        moduleName = "virtualisation";
        path = "boot.kernelModules";
        value = kvmKernelModules;
      })

      (facterLib.mkFacterAssignment {
        moduleName = "virtualisation";
        path = "boot.initrd.kernelModules";
        value = qemuInitrdKernelModules;
      })

      (facterLib.mkFacterAssignment {
        moduleName = "virtualisation";
        path = "boot.initrd.availableKernelModules";
        value = qemuAvailableKernelModules;
      })

      (lib.mkIf cfg.oracle.enable (
        facterLib.mkFacterAssignment {
          moduleName = "virtualisation";
          path = "virtualisation.virtualbox.guest.enable";
          value = lib.mkDefault true;
          facterValue = true;
        }
      ))

      (lib.mkIf cfg.hyperv.enable (
        facterLib.mkFacterAssignment {
          moduleName = "virtualisation";
          path = "virtualisation.hypervGuest.enable";
          value = lib.mkDefault true;
          facterValue = true;
        }
      ))

      (lib.mkIf cfg.parallels.enable (
        facterLib.mkFacterAssignment {
          moduleName = "virtualisation";
          path = "hardware.parallels.enable";
          value = lib.mkDefault true;
          facterValue = true;
        }
      ))

      (lib.mkIf (!options.nixpkgs.pkgs.isDefined && cfg.parallels.enable) (
        facterLib.mkFacterAssignment {
          moduleName = "virtualisation";
          path = "nixpkgs.config.allowUnfreePackages";
          value = [ "prl-tools" ];
        }
      ))
    ]
  );
}
