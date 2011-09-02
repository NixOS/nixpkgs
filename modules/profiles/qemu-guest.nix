# Common configuration for virtual machines running under QEMU (using
# virtio).

{ config, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_blk" "virtio_balloon" "virtio_console" ];
  boot.initrd.kernelModules = [ "virtio_balloon" ];
}
