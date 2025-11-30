{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  ruby_3_4,
  withPostgresql ? true,
  libpq,
  withSqlite ? false,
  sqlite,
}:

bundlerApp {
  pname = "ledger_web";
  gemdir = ./.;
  exes = [ "ledger_web" ];

  # "Source locally installed gems is ignoring... because it is missing extensions"
  ruby = ruby_3_4;

  buildInputs = lib.optional withPostgresql libpq ++ lib.optional withSqlite sqlite;

  passthru.updateScript = bundlerUpdateScript "ledger-web";

  meta = with lib; {
    description = "Web frontend to the Ledger CLI tool";
    homepage = "https://github.com/peterkeen/ledger-web";
    license = licenses.mit;
    maintainers = with maintainers; [
      peterhoeg
      manveru
      nicknovitski
    ];
    platforms = platforms.linux;
    mainProgram = "ledger_web";
  };
}
