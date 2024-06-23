{ lib, ... }:

{
  name = "qemu-vm-writable-store-image";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine = {
    virtualisation.useNixStoreImage = true;
    virtualisation.writableStore = true;
  };

  testScript = ''
    # Add a file to the store to show that you can actually write to it.
    machine.succeed("touch anything.nix")
    machine.succeed("nix-store --add anything.nix")
  '';
}
