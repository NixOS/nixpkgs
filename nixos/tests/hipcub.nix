import ./make-test-python.nix ({ lib, pkgs, ... }:

with lib;

{
  name = "hipcub";
  meta.maintainers = with maintainers; [ Madouura ];
  nodes.machine = { };

  # This will likely always fail due to this being a virtual machine with no gpu
  testScript = ''
    machine.wait_for_unit("default.target")
    machine.succeed("find ${(pkgs.hipcub.override { buildTests = true; }).test}/bin -maxdepth 1 -type f -executable -name 'test_*' > tests")

    # We can do this directly with find, but can't get the command to fail
    machine.succeed("for test in $(cat tests); do $test; done")
  '';
})
