{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;
  inherit (config.boot.kernelPackages) tt-kmd;

  cfg = config.hardware.tenstorrent;
in
{
  options.hardware.tenstorrent = {
    enable = mkEnableOption "Tenstorrent driver & utilities";

    hugepages = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to allocate 1 GiB hugepages for Tenstorrent cards at boot, using the setup
          shipped by tt-system-tools, and mount them at {file}`/dev/hugepages-1G`.

          TT-UMD needs them when the IOMMU is disabled or in passthrough mode. When the IOMMU
          translates DMA (the NixOS kernel default on AMD), TT-UMD maps host memory through it
          instead, and the reserved pages go unused.
        '';
      };

      count = mkOption {
        type = types.nullOr types.ints.positive;
        default = null;
        example = 8;
        description = ''
          Total number of 1 GiB hugepages to allocate, split evenly across the detected cards.
          `null` keeps the upstream default of 4 per Wormhole or Blackhole card and 1 per
          Grayskull card, each allocated on the card's NUMA node.
        '';
      };
    };

    iommuPassthrough = mkEnableOption ''
      the `iommu=pt` kernel parameter, which upstream's tenstorrent-tools package adds.
      With it, TT-UMD uses hugepages for host memory instead of IOMMU mappings
    '';
  };

  config = mkIf cfg.enable (mkMerge [
    {
      boot = {
        extraModulePackages = [ tt-kmd ];
        kernelModules = [ "tenstorrent" ];
      };

      services.udev.packages = [
        tt-kmd
      ];

      environment.systemPackages = with pkgs; [
        tt-smi
        tt-system-tools
      ];
    }

    (mkIf cfg.iommuPassthrough {
      boot.kernelParams = [ "iommu=pt" ];
    })

    (mkIf cfg.hugepages.enable {
      # mirrors upstream's tenstorrent-hugepages.service and dev-hugepages-1G.mount
      systemd.services.tenstorrent-hugepages = {
        description = "Configure hugepages for Tenstorrent ASICs";
        wantedBy = [ "sysinit.target" ];
        before = [ "sysinit.target" ];
        unitConfig.DefaultDependencies = false;
        environment = mkIf (cfg.hugepages.count != null) {
          TT_HUGEPAGES_OVERRIDE_FILE = toString (
            pkgs.writeText "tenstorrent-hugepages-override" (toString cfg.hugepages.count)
          );
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.tt-system-tools}/libexec/tt-system-tools/hugepages-setup";
        };
      };

      systemd.mounts = [
        {
          description = "Hugepages at /dev/hugepages-1G for Tenstorrent ASICs";
          what = "hugetlbfs";
          where = "/dev/hugepages-1G";
          type = "hugetlbfs";
          options = "pagesize=1G,mode=0777,nosuid,nodev";
          wantedBy = [ "sysinit.target" ];
          before = [ "sysinit.target" ];
          unitConfig = {
            DefaultDependencies = false;
            ConditionPathExists = "/sys/kernel/mm/hugepages/hugepages-1048576kB";
            ConditionCapability = "CAP_SYS_ADMIN";
          };
        }
      ];
    })
  ]);

  meta.maintainers = with lib.maintainers; [ RossComputerGuy ];
}
