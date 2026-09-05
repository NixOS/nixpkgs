{ lib, ... }:

{
  name = "sonarr";
  meta.maintainers = [ ];

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.sonarr.enable = true;
      };

    postgres = {
      services.sonarr = {
        enable = true;
        database.createLocally = true;
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("sonarr.service")
    machine.wait_for_open_port(8989)
    machine.succeed("curl --fail http://localhost:8989/")

    with subtest("PostgreSQL databases survive a restart"):
        postgres.wait_for_unit("postgresql.target")
        postgres.wait_for_unit("sonarr.service")
        postgres.wait_for_open_port(8989)
        postgres.succeed(
            "test \"$(sudo -u postgres psql -tAc \"select datdba::regrole::text from pg_database where datname = 'sonarr-main'\")\" = sonarr",
            "test \"$(sudo -u postgres psql -tAc \"select datdba::regrole::text from pg_database where datname = 'sonarr-log'\")\" = sonarr",
            "test \"$(sudo -u postgres psql -tAc \"select count(*) from pg_tables where schemaname = 'public'\" sonarr-main)\" -gt 0",
            "test \"$(sudo -u postgres psql -tAc \"select count(*) from pg_tables where schemaname = 'public'\" sonarr-log)\" -gt 0",
            "test ! -e /var/lib/sonarr/.config/NzbDrone/sonarr.db",
            "test ! -e /var/lib/sonarr/.config/NzbDrone/logs.db",
            "curl --fail http://localhost:8989/",
        )
        postgres.succeed("systemctl restart sonarr.service")
        postgres.wait_for_unit("sonarr.service")
        postgres.wait_for_open_port(8989)
        postgres.succeed(
            "test \"$(sudo -u postgres psql -tAc "
            "\"select count(*) from pg_tables where schemaname = 'public'\" sonarr-main)\" -gt 0",
            "test \"$(sudo -u postgres psql -tAc "
            "\"select count(*) from pg_tables where schemaname = 'public'\" sonarr-log)\" -gt 0",
            "curl --fail http://localhost:8989/",
        )
  '';
}
