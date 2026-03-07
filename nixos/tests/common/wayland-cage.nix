{ ... }:

{
  imports = [ ./user-account.nix ];
  services.cage = {
    enable = true;
    user = "alice";
  };

  virtualisation = {
    qemu.options = [ "-vga none -device virtio-gpu-pci" ];
  };
}
