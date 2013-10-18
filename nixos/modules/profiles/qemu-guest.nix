# Common configuration for virtual machines running under QEMU (using
# virtio).

{ config, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_blk" "9p" "9pnet_virtio" ];
  boot.kernelModules = [ "virtio_balloon" "virtio_console" ];
}
