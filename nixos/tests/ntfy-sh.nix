import ./make-test-python.nix {
  name = "ntfy-sh";

  nodes.machine = { ... }: {
    services.ntfy-sh.enable = true;
  };

  testScript = ''
    import json

    msg = "Test notification"

    machine.wait_for_unit("multi-user.target")

    machine.succeed(f"curl -d '{msg}' localhost:80/test")

    notif = json.loads(machine.succeed("curl -s localhost:80/test/json?poll=1"))

    assert msg == notif["message"], "Wrong message"
  '';
}
