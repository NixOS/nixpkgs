# This module enables all hardware supported by NixOS: i.e., all
# firmware is included, and all devices from which one may boot are
# enabled in the initrd.  Its primary use is in the NixOS installation
# CDs.

{ pkgs, lib,... }:
let
  platform = pkgs.stdenv.hostPlatform;
in
{

  # The initrd has to contain any module that might be necessary for
  # supporting the most important parts of HW like drives.
  boot.initrd.availableKernelModules =
    [ # SATA/PATA support.
      "ahci"

      "ata_piix"

      "sata_inic162x" "sata_nv" "sata_promise" "sata_qstor"
      "sata_sil" "sata_sil24" "sata_sis" "sata_svw" "sata_sx4"
      "sata_uli" "sata_via" "sata_vsc"

      "pata_ali" "pata_amd" "pata_artop" "pata_atiixp" "pata_efar"
      "pata_hpt366" "pata_hpt37x" "pata_hpt3x2n" "pata_hpt3x3"
      "pata_it8213" "pata_it821x" "pata_jmicron" "pata_marvell"
      "pata_mpiix" "pata_netcell" "pata_ns87410" "pata_oldpiix"
      "pata_pcmcia" "pata_pdc2027x" "pata_qdi" "pata_rz1000"
      "pata_serverworks" "pata_sil680" "pata_sis"
      "pata_sl82c105" "pata_triflex" "pata_via"
      "pata_winbond"

      # SCSI support (incomplete).
      "3w-9xxx" "3w-xxxx" "aic79xx" "aic7xxx" "arcmsr" "hpsa"

      # USB support, especially for booting from USB CD-ROM
      # drives.
      "uas"

      # SD cards.
      "sdhci_pci"

      # NVMe drives
      "nvme"

      # Firewire support.  Not tested.
      "ohci1394" "sbp2"

      # Virtio (QEMU, KVM etc.) support.
      "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "virtio_balloon" "virtio_console"

      # VMware support.
      "mptspi" "vmxnet3" "vsock"
    ] ++ lib.optional platform.isx86 "vmw_balloon"
    ++ lib.optionals (pkgs.stdenv.isi686 || pkgs.stdenv.isx86_64) [
      "vmw_vmci" "vmwgfx" "vmw_vsock_vmci_transport"

      # Hyper-V support.
      "hv_storvsc"
    ] ++ lib.optionals pkgs.stdenv.hostPlatform.isAarch [
      # Most of the following falls into two categories:
      #  - early KMS / early display
      #  - early storage (e.g. USB) support

      # Allows using framebuffer configured by the initial boot firmware
      "simplefb"

      # Allwinner support

      # Required for early KMS
      "sun4i-drm"
      "sun8i-mixer" # Audio, but required for kms

      # PWM for the backlight
      "pwm-sun4i"

      # Broadcom

      "vc4"
    ] ++ lib.optionals pkgs.stdenv.isAarch64 [
      # Most of the following falls into two categories:
      #  - early KMS / early display
      #  - early storage (e.g. USB) support

      # Broadcom

      "pcie-brcmstb"

      # Rockchip
      "dw-hdmi"
      "dw-mipi-dsi"
      "rockchipdrm"
      "rockchip-rga"
      "phy-rockchip-pcie"
      "pcie-rockchip-host"

      # Misc. uncategorized hardware

      # Used for some platform's integrated displays
      "panel-simple"
      "pwm-bl"

      # Power supply drivers, some platforms need them for USB
      "axp20x-ac-power"
      "axp20x-battery"
      "pinctrl-axp209"
      "mp8859"

      # USB drivers
      "xhci-pci-renesas"

      # Reset controllers
      "reset-raspberrypi" # Triggers USB chip firmware load.

      # Misc "weak" dependencies
      "analogix-dp"
      "analogix-anx6345" # For DP or eDP (e.g. integrated display)
    ];

  # Include lots of firmware.
  hardware.enableRedistributableFirmware = true;

  imports =
    [ ../hardware/network/zydas-zd1211.nix ];

}
