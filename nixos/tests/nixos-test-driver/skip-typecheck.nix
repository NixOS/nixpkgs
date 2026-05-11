/**
  nixosTests.simple, but with skipTypeCheck.
  This catches regressions in the wiring, e.g.
  https://github.com/NixOS/nixpkgs/pull/511225
*/
{
  name = "skip-typecheck";
  meta = {
    maintainers = [ ];
  };

  skipTypeCheck = true;

  nodes.machine = { };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.shutdown()
  '';
}
