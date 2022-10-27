import ./make-test-python.nix ({ lib, pkgs, ... }:

with lib;

{
  name = "hipsparse";
  meta.maintainers = with maintainers; [ Madouura ];
  nodes.machine = { };

  # This will likely always fail due to this being a virtual machine with no gpu
  testScript = ''
    machine.wait_for_unit("default.target")
    machine.succeed("${(pkgs.hipsparse.override { buildTests = true; }).test}/bin/hipsparse-test ")
  '';
})
