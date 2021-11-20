{ ... }:

{
  imports = [ ./user-account.nix ];
  services.cage = {
    enable = true;
    user = "alice";
  };

  virtualisation = {
    memorySize = 1024;
    qemu.options = [ "-vga virtio" ];
  };
}
