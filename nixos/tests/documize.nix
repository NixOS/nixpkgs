import ./make-test.nix ({ pkgs, lib, ...} : {
  name = "documize";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  machine = { pkgs, ... }: {
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
    startAll;

    $machine->waitForUnit("documize-server.service");
    $machine->waitForOpenPort(3000);

    my $dbhash = $machine->succeed("curl -f localhost:3000 "
                                  . " | grep 'property=\"dbhash' "
                                  . " | grep -Po 'content=\"\\K[^\"]*'"
                                  );

    chomp($dbhash);

    $machine->succeed("curl -X POST "
                      . "--data 'dbname=documize' "
                      . "--data 'dbhash=$dbhash' "
                      . "--data 'title=NixOS' "
                      . "--data 'message=Docs' "
                      . "--data 'firstname=John' "
                      . "--data 'lastname=Doe' "
                      . "--data 'email=john.doe\@nixos.org' "
                      . "--data 'password=verysafe' "
                      . "-f localhost:3000/api/setup"
                    );

    $machine->succeed('test "$(curl -f localhost:3000/api/public/meta | jq ".title" | xargs echo)" = "NixOS"');
  '';
})
