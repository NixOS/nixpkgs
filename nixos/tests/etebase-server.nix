import ./make-test-python.nix (
  { pkgs, ... }:

  let
    dataDir = "/var/lib/foobar";

  in
  {
    name = "etebase-server";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ felschr ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        services.etebase-server = {
          inherit dataDir;
          enable = true;
          settings.global.secret_file = toString (pkgs.writeText "secret" "123456");
        };
      };

    testScript = ''
      machine.wait_for_unit("etebase-server.service")
      machine.wait_for_open_port(8001)

      with subtest("Database & src-version were created"):
          machine.wait_for_file("${dataDir}/src-version")
          assert (
              "${pkgs.etebase-server}"
              in machine.succeed("cat ${dataDir}/src-version")
          )
          machine.wait_for_file("${dataDir}/db.sqlite3")
          machine.wait_for_file("${dataDir}/static")

      with subtest("Only allow access from allowed_hosts"):
          machine.succeed("curl -sSfL http://0.0.0.0:8001/")
          machine.fail("curl -sSfL http://127.0.0.1:8001/")
          machine.fail("curl -sSfL http://localhost:8001/")

      with subtest("Run tests"):
          machine.succeed("etebase-server check")
          machine.succeed("etebase-server test")

      with subtest("Create superuser"):
          machine.succeed(
              "etebase-server createsuperuser --no-input --username admin --email root@localhost"
          )
    '';
  }
)
