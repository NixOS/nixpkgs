{ package }:
{
  name = "3code-sandbox";

  nodes.machine.environment.systemPackages = [ package ];

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("mkdir -p /tmp/3code-allowed /tmp/3code-forbidden")
    machine.succeed("touch /tmp/3code-forbidden/writable-before-sandbox")

    with subtest("startup probe can execute Nix-store programs"):
        machine.succeed("3code sandbox restrict /tmp/3code-allowed -- true")

    with subtest("sandboxed shell can write inside the allowed directory"):
        machine.succeed(
            "3code sandbox restrict /tmp/3code-allowed -- /bin/sh -c "
            "'printf allowed > /tmp/3code-allowed/written'"
        )
        assert machine.succeed("cat /tmp/3code-allowed/written").strip() == "allowed"

    with subtest("sandboxed shell cannot write outside the allowed directory"):
        machine.fail(
            "3code sandbox restrict /tmp/3code-allowed -- /bin/sh -c "
            "'printf forbidden > /tmp/3code-forbidden/blocked'"
        )
        machine.succeed("test ! -e /tmp/3code-forbidden/blocked")
  '';
}
