import ./make-test-python.nix (
  { lib, pkgs, ... }:

  {
    name = "zammad";

    meta.maintainers = with lib.maintainers; [ taeer n0emis netali ];

    nodes.machine = { config, ... }: {
      virtualisation = {
        memorySize = 2048;
      };

      services.zammad.enable = true;
      services.zammad.secretKeyBaseFile = pkgs.writeText "secret" ''
        52882ef142066e09ab99ce816ba72522e789505caba224a52d750ec7dc872c2c371b2fd19f16b25dfbdd435a4dd46cb3df9f82eb63fafad715056bdfe25740d6
      '';
    };

    testScript = ''
      start_all()
      machine.wait_for_unit("postgresql.service")
      machine.wait_for_unit("redis-zammad.service")
      machine.wait_for_unit("zammad-web.service")
      machine.wait_for_unit("zammad-websocket.service")
      machine.wait_for_unit("zammad-worker.service")
      # wait for zammad to fully come up
      machine.sleep(120)

      # without the grep the command does not produce valid utf-8 for some reason
      with subtest("welcome screen loads"):
          machine.succeed(
              "curl -sSfL http://localhost:3000/ | grep '<title>Zammad Helpdesk</title>'"
          )
    '';
  }
)
