import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "scarab";

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.scarab ];
      };

    testScript = ''
      machine.succeed("${pkgs.scarab.meta.mainProgram} --version")
    '';

    meta = {
      inherit (pkgs.scarab.meta) maintainers;
    };
  }
)
