{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  runCommand,
  sqlint,
}:

bundlerApp {
  pname = "sqlint";
  gemdir = ./.;

  exes = [ "sqlint" ];

  passthru = {
    updateScript = bundlerUpdateScript "sqlint";
    tests.help = runCommand "sqlint-help-test" { } ''
      ${sqlint}/bin/sqlint --help
      touch $out
    '';
  };

  meta = {
    description = "Simple SQL linter";
    homepage = "https://github.com/purcell/sqlint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ariutta
      nicknovitski
      purcell
    ];
    platforms = lib.platforms.unix;
  };
}
