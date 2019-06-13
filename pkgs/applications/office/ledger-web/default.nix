{ lib, bundlerApp
, withPostgresql ? true, postgresql
, withSqlite ? false, sqlite
}:

bundlerApp rec {
  pname = "ledger_web";
  gemdir = ./.;
  exes = [ "ledger_web" ];

  buildInputs =    lib.optional withPostgresql postgresql
                ++ lib.optional withSqlite sqlite;

  meta = with lib; {
    description = "A web frontend to the Ledger CLI tool";
    homepage = https://github.com/peterkeen/ledger-web;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg manveru ];
    platforms = platforms.linux;
  };
}
