{ lib, config, ... }:
let
  cfg = config.virtualisation.vfio;

  vfioModules = [
    "vfio"
    "vfio-pci"
    "vfio_iommu_type1"
  ];

  mkSoftdeps = drivers: lib.concatStringsSep "\n" (map (d: "softdep ${d} pre: vfio-pci") drivers);
in
{
  options.virtualisation.vfio = {
    enable = lib.mkEnableOption "VFIO PCI passthrough" // {
      description = ''
        Whether to enable PCI device passthrough using VFIO.

        This allows to pass physical PCI devices (typically a GPU) directly
        to virtual machines.

        Prerequisites:
          - The hardware must support PCI passthrough (CPU must support hardware
            virtualization; CPU and motherboard must support IOMMU)
          - Hardware virtualization and IOMMU are enabled in BIOS
          - The PCI device is in an IOMMU group without devices required by the host
          - For Intel CPUs, `intel_iommu=on` must be set in {option}`boot.kernelParams`

        Specify devices to pass with {option}`virtualisation.vfio.pciIDs`.

        ::: {.warning}
        For GPU passthrough when early modesetting/KMS, Plymouth,
        or with host GPU drivers in the initrd,
        {option}`virtualisation.vfio.loadInInitrd` is required to be enabled.
        This, however, still does not ensure correct ordering of module loading
        and might not work.
        :::
      '';
    };

    pciIDs = lib.mkOption {
      type = lib.types.listOf (lib.types.strMatching "^([0-9a-fA-F]{4}):([0-9a-fA-F]{4})$");
      default = [ ];
      example = [
        "10de:2520" # NVIDIA GPU
        "10de:228e" # NVIDIA audio
      ];
      description = ''
        PCI vendor and device IDs to pass through.

        These IDs can be obtained by running:

        ```bash
        for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
            echo "IOMMU Group ''${g##*/}:"
            for d in $g/devices/*; do
                echo -e "\t$(lspci -nns ''${d##*/})"
            done;
        done;
        ```

        ::: {.note}
        All devices in the same IOMMU group must be passed together.
        :::
      '';
    };

    loadInInitrd = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Load the VFIO kernel modules in the initrd.

        This is necessary for GPU passthrough when early modesetting/KMS,
        Plymouth, or host GPU drivers are present in the initrd, but may not
        be sufficient on its own, as it still does not ensure correct ordering
        of module loading.
      '';
    };

    hostDrivers = lib.mkOption {
      type = lib.types.listOf (lib.types.strMatching "^[A-Za-z0-9_][A-Za-z0-9_-]*$");
      default = [ ];
      example = [
        "nvidia"
        "amdgpu"
        "i915"
      ];
      description = ''
        Kernel modules that should load after vfio-pci during normal system startup.

        This helps prevent host drivers from binding to passthrough devices
        after the initrd phase. It does not affect initrd module loading.

        An alternative is to blacklist these drivers using
        {option}`boot.blacklistedKernelModules`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelModules = vfioModules;

      # NOTE: this does not ensure correct module ordering in initrd
      initrd.kernelModules = lib.mkIf cfg.loadInInitrd vfioModules;

      extraModprobeConfig = lib.mkIf (cfg.hostDrivers != [ ]) (lib.mkAfter (mkSoftdeps cfg.hostDrivers));

      kernelParams = lib.mkIf (cfg.pciIDs != [ ]) [
        "vfio-pci.ids=${lib.concatStringsSep "," cfg.pciIDs}"
      ];

    };

    warnings = lib.optional (cfg.pciIDs == [ ]) ''
      virtualisation.vfio is enabled but no PCI IDs were specified.
      No devices will be bound to vfio-pci.
    '';
  };

  meta.maintainers = with lib.maintainers; [ d-brasher ];
}
