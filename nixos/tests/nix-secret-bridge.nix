import ./make-test-python.nix (
  { pkgs, ... }:

  {
    name = "nix-secret-bridge";

    meta = {
      maintainers = [ pkgs.lib.maintainers."mutasem-mk4" ];
    };

    nodes.machine =
      { ... }:
      {
        environment.systemPackages = [
          pkgs.nix-secret-bridge
        ];
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
      machine.succeed("nix-secret-bridge --help")
    '';
  }
)
