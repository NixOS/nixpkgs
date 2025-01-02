import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "nix-config";
    nodes.machine =
      { pkgs, ... }:
      {
        nix.settings = {
          nix-path = [ "nonextra=/etc/value.nix" ];
          extra-nix-path = [ "extra=/etc/value.nix" ];
        };
        environment.etc."value.nix".text = "42";
      };
    testScript = ''
      start_all()
      machine.wait_for_unit("nix-daemon.socket")
      # regression test for the workaround for https://github.com/NixOS/nix/issues/9487
      print(machine.succeed("nix-instantiate --find-file extra"))
      print(machine.succeed("nix-instantiate --find-file nonextra"))
    '';
  }
)
