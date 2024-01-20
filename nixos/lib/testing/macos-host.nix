{ config, lib, hostPkgs, ... }:

{
  config = lib.mkIf hostPkgs.stdenv.hostPlatform.isDarwin {
    defaults = {
      # On non-darwin, mounting the whole nix store from the host is the default because
      # this generally makes rebuilds of the VMs faster and the VMs smaller, while reducing
      # disk I/O.
      # However, on macOS it currently leads to many crashing guest processes.
      virtualisation.useNixStoreImage = true;

      # Without this, the store image uses "raw" instead of "qcow2" and
      # that throws some errors on macOS on startup of the VM
      # TODO: remove when `raw` errors are fixed.
      virtualisation.writableStore = true;
    };
  };
}
