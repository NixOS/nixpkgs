# All Hardware {#sec-profile-all-hardware}

Enables all hardware supported by NixOS: i.e., all firmware is included, and
all devices from which one may boot are enabled in the initrd. Its primary
use is in the NixOS installation CDs.

The enabled kernel modules include support for SATA and PATA, SCSI
(partially), USB, Firewire (untested), Virtio (QEMU, KVM, etc.), VMware, and
Hyper-V. Additionally, [](#opt-hardware.enableAllFirmware) is
enabled, and the firmware for the ZyDAS ZD1211 chipset is specifically
installed.
