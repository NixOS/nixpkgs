{ pkgs, ... }:
{
  name = "simple";
  meta = {
    maintainers = [ ];
  };

  nodes.machine =
    { ... }:
    {
      imports = [ ../modules/profiles/minimal.nix ];
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.shutdown()
  '';
}
