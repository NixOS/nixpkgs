import ./make-test.nix ({ pkgs, ... } : {

  name = "matrix-synapse";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ corngood ];
  };

  nodes = {
    # Since 0.33.0, matrix-synapse doesn't allow underscores in server names
    serverpostgres = args: {
      services.matrix-synapse.enable = true;
      services.matrix-synapse.database_type = "psycopg2";
    };

    serversqlite = args: {
      services.matrix-synapse.enable = true;
      services.matrix-synapse.database_type = "sqlite3";
    };
  };

  testScript = ''
    startAll;
    $serverpostgres->waitForUnit("matrix-synapse.service");
    $serverpostgres->waitUntilSucceeds("curl -Lk https://localhost:8448/");
    $serverpostgres->requireActiveUnit("postgresql.service");
    $serversqlite->waitForUnit("matrix-synapse.service");
    $serversqlite->waitUntilSucceeds("curl -Lk https://localhost:8448/");
    $serversqlite->mustSucceed("[ -e /var/lib/matrix-synapse/homeserver.db ]");
  '';

})
