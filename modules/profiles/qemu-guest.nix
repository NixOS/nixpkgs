# Common configuration for virtual machines running under QEMU (using
# virtio).

{ config, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_blk" ];
  boot.kernelModules = [ "virtio_balloon" "virtio_console" ];
}
