{ lib, config, ... }:

{
  name = "prowlarr";
  meta.maintainers = [ ];

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.prowlarr.enable = true;
        specialisation.customDataDir = {
          inheritParentConfig = true;
          configuration.services.prowlarr.dataDir = "/srv/prowlarr";
        };
      };

    postgres = {
      services.prowlarr = {
        enable = true;
        database.createLocally = true;
      };
    };
  };

  testScript = ''
    def verify_prowlarr_works():
      machine.wait_for_unit("prowlarr.service")
      machine.wait_for_open_port(9696)
      response = machine.succeed("curl --fail http://localhost:9696/")
      assert '<title>Prowlarr</title>' in response, "Login page didn't load successfully"
      machine.succeed("[ -d /var/lib/prowlarr ]")

    with subtest("Prowlarr starts and responds to requests"):
      verify_prowlarr_works()

    with subtest("Prowlarr data directory migration works"):
      machine.systemctl("stop prowlarr.service")
      machine.succeed("mkdir -p /tmp/prowlarr-migration")
      machine.succeed("rsync -a -delete /var/lib/prowlarr/ /tmp/prowlarr-migration")
      machine.succeed("${config.nodes.machine.system.build.toplevel}/specialisation/customDataDir/bin/switch-to-configuration test")
      machine.wait_for_unit("var-lib-private-prowlarr.mount")
      machine.succeed("rsync -a -delete /tmp/prowlarr-migration/ /var/lib/prowlarr")
      machine.systemctl("restart prowlarr.service")
      # Check that we're using a bind mount when using a non-default dataDir
      machine.succeed("findmnt /var/lib/private/prowlarr | grep /srv/prowlarr")
      verify_prowlarr_works()

    with subtest("PostgreSQL databases survive a restart"):
      postgres.wait_for_unit("postgresql.target")
      postgres.wait_for_unit("prowlarr.service")
      postgres.wait_for_open_port(9696)
      postgres.succeed(
          "test \"$(sudo -u postgres psql -tAc \"select datdba::regrole::text from pg_database where datname = 'prowlarr-main'\")\" = prowlarr",
          "test \"$(sudo -u postgres psql -tAc \"select datdba::regrole::text from pg_database where datname = 'prowlarr-log'\")\" = prowlarr",
          "test \"$(sudo -u postgres psql -tAc \"select count(*) from pg_tables where schemaname = 'public'\" prowlarr-main)\" -gt 0",
          "test \"$(sudo -u postgres psql -tAc \"select count(*) from pg_tables where schemaname = 'public'\" prowlarr-log)\" -gt 0",
          "test ! -e /var/lib/private/prowlarr/prowlarr.db",
          "test ! -e /var/lib/private/prowlarr/logs.db",
          "curl --fail http://localhost:9696/",
      )
      postgres.succeed("systemctl restart prowlarr.service")
      postgres.wait_for_unit("prowlarr.service")
      postgres.wait_for_open_port(9696)
      postgres.succeed(
          "test \"$(sudo -u postgres psql -tAc "
          "\"select count(*) from pg_tables where schemaname = 'public'\" prowlarr-main)\" -gt 0",
          "test \"$(sudo -u postgres psql -tAc "
          "\"select count(*) from pg_tables where schemaname = 'public'\" prowlarr-log)\" -gt 0",
          "curl --fail http://localhost:9696/",
      )
  '';
}
