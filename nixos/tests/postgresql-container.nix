{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  test-sql = pkgs.writeText "postgresql-test" ''
    CREATE EXTENSION pgcrypto; -- just to check if lib loading works
    CREATE TABLE sth (
      id int
    );
    INSERT INTO sth (id) VALUES (1);
    INSERT INTO sth (id) VALUES (1);
    INSERT INTO sth (id) VALUES (1);
    INSERT INTO sth (id) VALUES (1);
    INSERT INTO sth (id) VALUES (1);
    CREATE TABLE xmltest ( doc xml );
    INSERT INTO xmltest (doc) VALUES ('<test>ok</test>'); -- check if libxml2 enabled
  '';

in makeTest {
    name = "postgresql-container";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ roberth ];
    };

    machine = {...}:
      {
        virtualisation.docker = {
          enable = true;
        };
        virtualisation.memorySize = 4096;
        virtualisation.diskSize = 4096;
        environment.systemPackages = [
          # add postgresql for its client; psql
          pkgs.postgresql
        ];
      };

    testScript = ''
      def check_count(statement, lines):
          return 'test $(psql --host=127.0.0.1 --username=postgres postgres -tAc "{}"|wc -l) -eq {}'.format(
              statement, lines
          )


      machine.start()
      machine.wait_for_unit("docker.socket")
      machine.succeed("${pkgs.dockerTools.examples.postgresql} | docker load")
      machine.succeed("docker run -d -p5432:5432 --name pg --restart=always --stop-signal SIGINT nixpkgs-postgresql")
      machine.succeed("docker logs --tail 1000 -f pg >&2 &")

      with subtest("Postgresql comes up"):
          machine.wait_until_succeeds(
              "cat ${test-sql} | psql --host=127.0.0.1 --username=postgres"
          )

      with subtest("Postgresql survives restart"):
          machine.shutdown()
          import time
          time.sleep(2)
          machine.start()
          machine.wait_until_succeeds("""
              echo 'SELECT 1;' | psql --host=127.0.0.1 --username=postgres
          """)

      machine.fail(check_count("SELECT * FROM sth;", 3))
      machine.succeed(check_count("SELECT * FROM sth;", 5))
      machine.fail(check_count("SELECT * FROM sth;", 4))
      machine.succeed(check_count("SELECT xpath('/test/text()', doc) FROM xmltest;", 1))

      machine.shutdown()
    '';

  }

