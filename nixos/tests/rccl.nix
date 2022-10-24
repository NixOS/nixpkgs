import ./make-test-python.nix ({ lib, pkgs, ... }:

with lib;

{
  name = "rccl";
  meta.maintainers = with maintainers; [ Madouura ];
  nodes.machine = { };

  # This will likely always fail due to this being a virtual machine with no gpu
  testScript = ''
    machine.wait_for_unit("default.target")
    machine.succeed("${(pkgs.rccl.override { buildTests = true; }).test}/bin/UnitTests")
  '';
})
