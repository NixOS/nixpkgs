{
  lib,
  bundlerApp,
  bundlerUpdateScript,
<<<<<<< HEAD
  ruby_3_4,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  withPostgresql ? true,
  libpq,
  withSqlite ? false,
  sqlite,
}:

bundlerApp {
  pname = "ledger_web";
  gemdir = ./.;
  exes = [ "ledger_web" ];

<<<<<<< HEAD
  # "Source locally installed gems is ignoring... because it is missing extensions"
  ruby = ruby_3_4;

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  buildInputs = lib.optional withPostgresql libpq ++ lib.optional withSqlite sqlite;

  passthru.updateScript = bundlerUpdateScript "ledger-web";

<<<<<<< HEAD
  meta = {
    description = "Web frontend to the Ledger CLI tool";
    homepage = "https://github.com/peterkeen/ledger-web";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      manveru
      nicknovitski
    ];
    platforms = lib.platforms.linux;
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "ledger_web";
  };
}
