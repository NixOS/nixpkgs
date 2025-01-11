import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "simple";
    meta = with pkgs.lib.maintainers; {
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
)
