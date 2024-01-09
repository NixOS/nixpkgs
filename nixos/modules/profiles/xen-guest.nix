# Common configuration for virtual machines running under Xen
{lib, ...}: {
  # Kernel modules used during the boot process
  boot.initrd.availableKernelModules = [
    "xen_blkfront"  # disks
    "xen_netfront"  # network
    "xen_pcifront"  # PCI for PV guests
    "xen_scsifront" # SCSI passthrough
    "xen_hcd" # usb passthrough
    # "hvc_xen"          # console                                  # builtin enabled by HVC_XEN_FRONTEND
    # "xen_pvh"          # Support for running as a PVH guest       # builtin enabled by XEN_PVH
    # "xen_platform_pci" # Support running as a Xen PVHVM guest     # builtin enabled by XEN_PVHVM_GUEST
    # "sys-hypervisor"   # Create xen entries under /sys/hypervisor # builtin enabled by XEN_SYS_HYEPRVISOR
  ];
  # Kernel modules used in the running system
  boot.kernelModules = [
    "xen_wdt"       # watchdog, Xen >= 4.0
    "xen_balloon"   # memory balloon
    "xen_fbfront"   # framebuffer
    "drm_xen_front" # Direct Rendering Manager frontend
    "xen_kbdfront"  # keyboard/mouse/pointer/multi-touch
    "xen_tpmfront"  # TPM
    "snd_xen_front" # sound
    "xenfs"         # Xen filesystem
    "9pnet_xen"     # 9P Xen Transport
  ];

  # Don't run ntpd, since we should get the correct time from Dom0.
  services.timesyncd.enable = lib.mkDefault false;
}
