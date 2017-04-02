{ lib, bundlerEnv, ruby
, withPostgresql ? true, postgresql
, withSqlite ? false, sqlite
}:

bundlerEnv rec {
  name = "ledger-web-${version}";

  version = (import ./gemset.nix).ledger_web.version;
  inherit ruby;
  gemdir = ./.;

  buildInputs =    lib.optional withPostgresql postgresql
                ++ lib.optional withSqlite sqlite;

  meta = with lib; {
    description = "A web frontend to the Ledger CLI tool";
    homepage = https://github.com/peterkeen/ledger-web;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
