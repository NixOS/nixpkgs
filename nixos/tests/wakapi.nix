{ lib, ... }:
{
  name = "Wakapi";

  nodes = {
    wakapiPsql = {
      services.wakapi = {
        enable = true;
        settings = {
          server.port = 3000; # upstream default, set explicitly in case upstream changes it
          db = {
            dialect = "postgres"; # `createLocally` only supports postgres
            host = "/run/postgresql";
            port = 5432; # service will fail if port is not set
            name = "wakapi";
            user = "wakapi";
          };
        };

        # Automatically create our database
        database.createLocally = true; # only works with Postgresql for now

        # Created with `cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1`
        # Prefer passwordSaltFile in production.
        passwordSalt = "NpqCY7eY7fMoIWYmPx5mAgr6YoSlXSuI";
      };
    };

    wakapiSqlite = {
      services.wakapi = {
        enable = true;
        settings = {
          server.port = 3001;
          db = {
            dialect = "sqlite3";
            name = "wakapi";
            user = "wakapi";
          };
        };

        passwordSalt = "NpqCY7eY7fMoIWYmPx5mAgr6YoSlXSuI";
      };
    };
  };

  # Test that service works under both postgresql and sqlite3
  # by starting all machines, and curling the default address.
  # This is not very comprehensive for a test, but it should
  # catch very basic mistakes in the module.
  testScript = ''
    with subtest("Test Wakapi with postgresql backend"):
      wakapiPsql.start()
      wakapiPsql.wait_for_unit("wakapi.service")
      wakapiPsql.wait_for_open_port(3000)
      wakapiPsql.succeed("curl --fail http://localhost:3000")

    with subtest("Test Wakapi with sqlite3 backend"):
      wakapiSqlite.start()
      wakapiSqlite.wait_for_unit("wakapi.service")
      wakapiSqlite.wait_for_open_port(3001)
      wakapiSqlite.succeed("curl --fail http://localhost:3001")
  '';

  meta.maintainers = [ lib.maintainers.NotAShelf ];
}
