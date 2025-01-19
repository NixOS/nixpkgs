{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  withPostgresql ? true,
  postgresql,
  withSqlite ? false,
  sqlite,
}:

bundlerApp {
  pname = "ledger_web";
  gemdir = ./.;
  exes = [ "ledger_web" ];

  buildInputs = lib.optional withPostgresql postgresql ++ lib.optional withSqlite sqlite;

  passthru.updateScript = bundlerUpdateScript "ledger-web";

  meta = {
    description = "Web frontend to the Ledger CLI tool";
    homepage = "https://github.com/peterkeen/ledger-web";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      peterhoeg
      manveru
      nicknovitski
    ];
    platforms = lib.platforms.linux;
    mainProgram = "ledger_web";
  };
}
