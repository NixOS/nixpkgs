{ lib, pkgs, ... }:
{
  name = "healthchecks";

  meta = with lib.maintainers; {
    maintainers = [ phaer ];
  };

  nodes.machine =
    { ... }:
    {
      services.healthchecks = {
        enable = true;
        settings = {
          SITE_NAME = "MyUniqueInstance";
          COMPRESS_ENABLED = "True";
          SECRET_KEY_FILE = pkgs.writeText "secret" "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        };
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("healthchecks.target")
    machine.wait_until_succeeds("journalctl --since -1m --unit healthchecks --grep Listening")

    with subtest("Home screen loads"):
        machine.succeed(
            "curl -sSfL http://localhost:8000 | grep '<title>Log In'"
        )

    with subtest("Setting SITE_NAME via freeform option works"):
        machine.succeed(
            "curl -sSfL http://localhost:8000 | grep 'MyUniqueInstance</title>'"
        )

    with subtest("Manage script works"):
        # "shell" sucommand should succeed, needs python in PATH.
        t.assertIn(
          "\nfoo\n",
          machine.succeed("echo 'print(\"foo\")' | sudo -u healthchecks healthchecks-manage shell")
        )
        # Shouldn't fail if not called by healthchecks user
        t.assertIn(
          "\nfoo\n",
          machine.succeed("echo 'print(\"foo\")' | healthchecks-manage shell")
        )
  '';
}
