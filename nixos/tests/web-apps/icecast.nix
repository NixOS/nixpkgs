import ../make-test-python.nix ({ lib, pkgs, ... }: {
  name = "icecast";

  meta = with lib.maintainers; {
    maintainers = [ ];
  };

  nodes.machine = { ... }: {
    services.icecast = {
      enable = true;
      admin.password = "test";
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("icecast.service")
    #machine.wait_until_succeeds("journalctl --since -1m --unit icecast --grep TODO")

    with subtest("Home screen loads"):
        machine.succeed(
            "curl -sSfL http://[::]:8000"
        )
  '';
})
