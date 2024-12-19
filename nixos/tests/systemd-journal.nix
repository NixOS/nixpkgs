import ./make-test-python.nix (
  { pkgs, ... }:

  {
    name = "systemd-journal";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ lewo ];
    };

    nodes.machine = { };

    testScript = ''
      machine.wait_for_unit("multi-user.target")

      machine.succeed("journalctl --grep=systemd")
    '';
  }
)
