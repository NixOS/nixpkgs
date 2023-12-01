import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "documize";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ];
  };

  nodes.machine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.jq ];

    services.documize = {
      enable = true;
      port = 3000;
      dbtype = "postgresql";
      db = "host=localhost port=5432 sslmode=disable user=documize password=documize dbname=documize";
    };

    systemd.services.documize-server = {
      after = [ "postgresql.service" ];
      requires = [ "postgresql.service" ];
    };

    services.postgresql = {
      enable = true;
      initialScript = pkgs.writeText "psql-init" ''
        CREATE ROLE documize WITH LOGIN PASSWORD 'documize';
        CREATE DATABASE documize WITH OWNER documize;
      '';
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("documize-server.service")
    machine.wait_for_open_port(3000)

    dbhash = machine.succeed(
        "curl -f localhost:3000 | grep 'property=\"dbhash' | grep -Po 'content=\"\\K[^\"]*'"
    )

    dbhash = dbhash.strip()

    machine.succeed(
        (
            "curl -X POST"
            " --data 'dbname=documize'"
            " --data 'dbhash={}'"
            " --data 'title=NixOS'"
            " --data 'message=Docs'"
            " --data 'firstname=Bob'"
            " --data 'lastname=Foobar'"
            " --data 'email=bob.foobar@nixos.org'"
            " --data 'password=verysafe'"
            " -f localhost:3000/api/setup"
        ).format(dbhash)
    )

    machine.succeed(
        'test "$(curl -f localhost:3000/api/public/meta | jq ".title" | xargs echo)" = "NixOS"'
    )
  '';
})
