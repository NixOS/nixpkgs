{ ... }:

{
  imports = [ ./user-account.nix ];
  services.cage = {
    enable = true;
    user = "alice";
  };

  virtualisation = {
    qemu.options = [ "-vga virtio" ];
  };
}
