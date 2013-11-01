# This module enables all hardware supported by NixOS: i.e., all
# firmware is included, and all devices from which one may boot are
# enabled in the initrd.  Its primary use is in the NixOS installation
# CDs.

{ config, pkgs, ... }:

{

  # The initrd has to contain any module that might be necessary for
  # mounting the CD/DVD.
  boot.initrd.availableKernelModules =
    [ # SATA/PATA support.
      "ahci"

      "ata_piix"

      "sata_inic162x" "sata_nv" "sata_promise" "sata_qstor"
      "sata_sil" "sata_sil24" "sata_sis" "sata_svw" "sata_sx4"
      "sata_uli" "sata_via" "sata_vsc"

      "pata_ali" "pata_amd" "pata_artop" "pata_atiixp"
      "pata_cs5520" "pata_cs5530" "pata_cs5535" "pata_efar"
      "pata_hpt366" "pata_hpt37x" "pata_hpt3x2n" "pata_hpt3x3"
      "pata_it8213" "pata_it821x" "pata_jmicron" "pata_marvell"
      "pata_mpiix" "pata_netcell" "pata_ns87410" "pata_oldpiix"
      "pata_pcmcia" "pata_pdc2027x" "pata_qdi" "pata_rz1000"
      "pata_sc1200" "pata_serverworks" "pata_sil680" "pata_sis"
      "pata_sl82c105" "pata_triflex" "pata_via"
      "pata_winbond"

      # SCSI support (incomplete).
      "3w-9xxx" "3w-xxxx" "aic79xx" "aic7xxx" "arcmsr"

      # USB support, especially for booting from USB CD-ROM
      # drives.
      "usb_storage"

      # Firewire support.  Not tested.
      "ohci1394" "sbp2"

      # Virtio (QEMU, KVM etc.) support.
      "virtio_net" "virtio_pci" "virtio_blk" "virtio_balloon" "virtio_console"

      # Keyboards
      "hid_apple"
    ];

  # Include lots of firmware.
  hardware.enableAllFirmware = true;

  imports =
    [ ../hardware/network/zydas-zd1211.nix ];

}
