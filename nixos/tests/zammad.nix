import ./make-test-python.nix (
  { lib, pkgs, ... }:

  {
    name = "zammad";

    meta.maintainers = with lib.maintainers; [
      taeer
      n0emis
      netali
    ];

    nodes.machine =
      { config, ... }:
      {
        virtualisation = {
          memorySize = 2048;
        };

        services.zammad.enable = true;
        services.zammad.secretKeyBaseFile = pkgs.writeText "secret" ''
          52882ef142066e09ab99ce816ba72522e789505caba224a52d750ec7dc872c2c371b2fd19f16b25dfbdd435a4dd46cb3df9f82eb63fafad715056bdfe25740d6
        '';

        systemd.services.zammad-locale-cheat =
          let
            cfg = config.services.zammad;
          in
          {
            serviceConfig = {
              Type = "simple";
              Restart = "always";

              User = "zammad";
              Group = "zammad";
              PrivateTmp = true;
              StateDirectory = "zammad";
              WorkingDirectory = cfg.dataDir;
            };
            wantedBy = [ "zammad-web.service" ];
            description = "Hack in the locale files so zammad doesn't try to access the internet";
            script = ''
              mkdir -p ./config/translations
              VERSION=$(cat ${cfg.package}/VERSION)

              # If these files are not in place, zammad will try to access the internet.
              # For the test, we only need to supply en-us.
              echo '[{"locale":"en-us","alias":"en","name":"English (United States)","active":true,"dir":"ltr"}]' \
                > ./config/locales-$VERSION.yml
              echo '[{"locale":"en-us","format":"time","source":"date","target":"mm/dd/yyyy","target_initial":"mm/dd/yyyy"},{"locale":"en-us","format":"time","source":"timestamp","target":"mm/dd/yyyy HH:MM","target_initial":"mm/dd/yyyy HH:MM"}]' \
                > ./config/translations/en-us-$VERSION.yml
            '';
          };
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
