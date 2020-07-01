let
  f = backend: import ./make-test-python.nix ({ pkgs, ... }: {
    name = "ihatemoney-${backend}";
    machine = { lib, ... }: {
      services.ihatemoney = {
        enable = true;
        enablePublicProjectCreation = true;
        inherit backend;
        uwsgiConfig = {
          http = ":8000";
        };
      };
      boot.cleanTmpDir = true;
      # ihatemoney needs a local smtp server otherwise project creation just crashes
      services.opensmtpd = {
        enable = true;
        serverConfiguration = ''
          listen on lo
          action foo relay
          match from any for any action foo
        '';
      };
    };
    testScript = ''
      machine.wait_for_open_port(8000)
      machine.wait_for_unit("uwsgi.service")

      assert '"yay"' in machine.succeed(
          "curl -X POST http://localhost:8000/api/projects -d 'name=yay&id=yay&password=yay&contact_email=yay\@example.com'"
      )
      owner, timestamp = machine.succeed(
          "stat --printf %U:%G___%Y /var/lib/ihatemoney/secret_key"
      ).split("___")
      assert "ihatemoney:ihatemoney" == owner

      with subtest("Restart machine and service"):
          machine.shutdown()
          machine.start()
          machine.wait_for_open_port(8000)
          machine.wait_for_unit("uwsgi.service")

      with subtest("check that the database is really persistent"):
          machine.succeed("curl --basic -u yay:yay http://localhost:8000/api/projects/yay")

      with subtest("check that the secret key is really persistent"):
          timestamp2 = machine.succeed("stat --printf %Y /var/lib/ihatemoney/secret_key")
          assert timestamp == timestamp2

      assert "ihatemoney" in machine.succeed("curl http://localhost:8000")
    '';
  });
in {
  ihatemoney-sqlite = f "sqlite";
  ihatemoney-postgresql = f "postgresql";
}
