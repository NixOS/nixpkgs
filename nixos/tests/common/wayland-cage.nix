{ pkgs, ... }: {
  imports = [ ./user-account.nix ];
  services.cage = {
    enable = true;
    user = "alice";
  };

  virtualisation.memorySize = 1024;
  # Need to switch to a different GPU driver than the default one (-vga std) so that Cage can launch:
  virtualisation.qemu.options = [ "-vga none -device virtio-gpu-pci" ];
}
