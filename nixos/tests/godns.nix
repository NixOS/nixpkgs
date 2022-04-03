import ./make-test-python.nix ({ lib, ... }:

with lib;

{
  name = "godns";
  meta.maintainers = with maintainers; [ tboerger ];

  nodes.machine =
    { pkgs, ... }:
    { services.godns.enable = true; };

  testScript = ''
    machine.wait_for_unit("godns.service")
  '';
})
