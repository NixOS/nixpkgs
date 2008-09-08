[
  # The initrd should contain any modules necessary for
  # mounting the CD.
  
  # SATA/PATA support.
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
  # "pata_winbond" <-- causes timeouts in sd_mod
  
  # SCSI support (incomplete).
  "3w-9xxx" "3w-xxxx" "aic79xx" "aic7xxx" "arcmsr" 
  
  # USB support, especially for booting from USB CD-ROM
  # drives.	Also include USB keyboard support for when
  # something goes wrong in stage 1.
  "ehci_hcd"
  "ohci_hcd"
  "usbhid"
  "usb_storage"
  
  # Firewire support.	Not tested.
  "ohci1394" "sbp2"
  
  # Wait for SCSI devices to appear.
  "scsi_wait_scan"
  
  # Needed for live-CD operation.
  "aufs"
]
