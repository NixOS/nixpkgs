import ./make-test-python.nix ({ pkgs, ...} : {
  name = "slimserver";
  meta.maintainers = with pkgs.lib.maintainers; [ adamcstephens ];

  nodes.machine = { ... }: {
    services.slimserver.enable = true;
  };

  testScript =
    ''
      machine.wait_for_unit("slimserver.service")
      machine.wait_for_open_port(9000)
      machine.succeed("curl http://localhost:9000")
      machine.wait_until_succeeds("journalctl -eu slimserver.service | grep 'Completed dbOptimize Scan'")
    '';
})
