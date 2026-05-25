import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "ccache";

    nodes.machine =
      { ... }:
      {
        imports = [ ../modules/profiles/minimal.nix ];
        environment.systemPackages = [ pkgs.hello ];
        programs.ccache = {
          enable = true;
          packageNames = [ "hello" ];
        };
      };

    testScript = ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      machine.succeed("nix-ccache --show-stats")
      machine.succeed("hello")
      machine.shutdown()
    '';
  }
)
