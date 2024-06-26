import ./make-test-python.nix {
  name = "ntfy-sh";

  nodes.machine =
    { ... }:
    {
      services.ntfy-sh.enable = true;
      services.ntfy-sh.settings.base-url = "http://localhost:2586";
    };

  testScript = ''
    import json

    msg = "Test notification"

    machine.wait_for_unit("multi-user.target")

    machine.wait_for_open_port(2586)

    machine.succeed(f"curl -d '{msg}' localhost:2586/test")

    notif = json.loads(machine.succeed("curl -s localhost:2586/test/json?poll=1"))

    assert msg == notif["message"], "Wrong message"

    machine.succeed("ntfy user list")
  '';
}
