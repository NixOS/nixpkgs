{
  warnings = ''
    Importing qemu-vm.nix has been deprecated. Set `virtualisation.qemuGuest.enable = true;` instead.
    The options declared in qemu-vm.nix have been moved to qemu-guest.nix and imported unconditionally, so there is no additional import needed to configure them, but they will only have an effect if virtualisation.qemuGuest.enable = true;
  '';
  virtualisation.qemuGuest.enable = true;
}
