import ../make-test-python.nix (
  { lib, ... }:

    {
      name = "zammad";

      meta.maintainers = with lib.maintainers; [ garbas ];

      nodes.machine = {
        services.zammad.enable = true;
        services.zammad.secretsFile = "${./test_secrets}";
      };

      testScript = ''
        start_all()
        machine.wait_for_unit("postgresql.service")
        machine.wait_for_unit("zammad-web.service")
        machine.wait_for_unit("zammad-websocket.service")
        machine.wait_for_unit("zammad-scheduler.service")
        # without the grep the command does not produce valid utf-8 for some reason
        with subtest("welcome screen loads"):
            machine.succeed(
                "curl -sSfL http://localhost:3000/ | grep '<title>Zammad Helpdesk</title>'"
            )
      '';
    }
)
