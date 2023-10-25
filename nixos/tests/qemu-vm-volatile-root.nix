# Test that the root filesystem is a volatile tmpfs.

{ lib, ... }:

{
  name = "qemu-vm-volatile-root";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine = _: {
    virtualisation.diskImage = null;
  };

  testScript = ''
    machine.succeed("findmnt --kernel --types tmpfs /")
  '';
}
