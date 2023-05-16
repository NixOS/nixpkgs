import ./make-test-python.nix {
  name = "ntfy-sh";

  nodes.machine = { ... }: {
    services.ntfy-sh.enable = true;
<<<<<<< HEAD
    services.ntfy-sh.settings.base-url = "http://localhost:2586";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  testScript = ''
    import json

    msg = "Test notification"

    machine.wait_for_unit("multi-user.target")

<<<<<<< HEAD
    machine.wait_for_open_port(2586)

    machine.succeed(f"curl -d '{msg}' localhost:2586/test")

    notif = json.loads(machine.succeed("curl -s localhost:2586/test/json?poll=1"))

    assert msg == notif["message"], "Wrong message"

    machine.succeed("ntfy user list")
=======
    machine.wait_for_open_port(80)

    machine.succeed(f"curl -d '{msg}' localhost:80/test")

    notif = json.loads(machine.succeed("curl -s localhost:80/test/json?poll=1"))

    assert msg == notif["message"], "Wrong message"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';
}
