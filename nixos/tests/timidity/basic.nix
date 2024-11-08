import ../make-test-python.nix (
  { pkgs, ... }:
  {

    name = "timidity";

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.timidity ];
      };

    testScript = ''
      start_all ()

      ## TiMidity++ is around.
      machine.succeed("command -v timidity")
    '';
  }
)
