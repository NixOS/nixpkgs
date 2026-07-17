{ lib, ... }:

{
  name = "radarr";
  meta.maintainers = [ ];

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.radarr.enable = true;
      };

    postgres = {
      services.radarr = {
        enable = true;
        database.createLocally = true;
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("radarr.service")
    machine.wait_for_open_port(7878)
    machine.succeed("curl --fail http://localhost:7878/")

    with subtest("PostgreSQL databases survive a restart"):
        postgres.wait_for_unit("postgresql.target")
        postgres.wait_for_unit("radarr.service")
        postgres.wait_for_open_port(7878)
        postgres.succeed(
            "test \"$(sudo -u postgres psql -tAc \"select datdba::regrole::text from pg_database where datname = 'radarr-main'\")\" = radarr",
            "test \"$(sudo -u postgres psql -tAc \"select datdba::regrole::text from pg_database where datname = 'radarr-log'\")\" = radarr",
            "test \"$(sudo -u postgres psql -tAc \"select count(*) from pg_tables where schemaname = 'public'\" radarr-main)\" -gt 0",
            "test \"$(sudo -u postgres psql -tAc \"select count(*) from pg_tables where schemaname = 'public'\" radarr-log)\" -gt 0",
            "test ! -e /var/lib/radarr/.config/Radarr/radarr.db",
            "test ! -e /var/lib/radarr/.config/Radarr/logs.db",
            "curl --fail http://localhost:7878/",
        )
        postgres.succeed("systemctl restart radarr.service")
        postgres.wait_for_unit("radarr.service")
        postgres.wait_for_open_port(7878)
        postgres.succeed(
            "test \"$(sudo -u postgres psql -tAc "
            "\"select count(*) from pg_tables where schemaname = 'public'\" radarr-main)\" -gt 0",
            "test \"$(sudo -u postgres psql -tAc "
            "\"select count(*) from pg_tables where schemaname = 'public'\" radarr-log)\" -gt 0",
            "curl --fail http://localhost:7878/",
        )
  '';
}
