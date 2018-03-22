import ./make-test.nix ({ pkgs, ... } : {

  name = "matrix-synapse";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ corngood ];
  };

  nodes = {
    server_postgres = args: {
      services.matrix-synapse.enable = true;
      services.matrix-synapse.database_type = "psycopg2";
    };

    server_sqlite = args: {
      services.matrix-synapse.enable = true;
      services.matrix-synapse.database_type = "sqlite3";
    };
  };

  testScript = ''
    startAll;
    $server_postgres->waitForUnit("matrix-synapse.service");
    $server_postgres->waitUntilSucceeds("curl -Lk https://localhost:8448/");
    $server_postgres->requireActiveUnit("postgresql.service");
    $server_sqlite->waitForUnit("matrix-synapse.service");
    $server_sqlite->waitUntilSucceeds("curl -Lk https://localhost:8448/");
    $server_sqlite->mustSucceed("[ -e /var/lib/matrix-synapse/homeserver.db ]");
  '';

})
