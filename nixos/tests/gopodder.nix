{ lib, ... }: {
  name = "gopodder";

  nodes = {
    vm1 = { pkgs, ... }: {
      services.gopodder = {
        enable = true;
        port = 1234;
        logLevel = "debug";
      };
    };
    vm2 = { pkgs, ... }: {
      services.gopodder = {
        enable = true;
        port = 8080;
        database = {
          type = "postgres";
          createLocally = true;
        };
      };
    };
  };

  testScript = ''
    start_all()

    with subtest("SQLite backend on custom port"):
        vm1.wait_for_unit("gopodder.service")
        vm1.wait_for_open_port(1234)
        vm1.succeed("curl --fail http://localhost:1234/")
        vm1.succeed("test -d /var/lib/gopodder")

    with subtest("PostgreSQL local database backend"):
        vm2.wait_for_unit("postgresql.service")
        vm2.wait_for_unit("gopodder.service")
        vm2.wait_for_open_port(8080)
        vm2.succeed("curl --fail http://localhost:8080/")
  '';
}
