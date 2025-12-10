{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "sqlint";
  gemdir = ./.;

  exes = [ "sqlint" ];

  passthru.updateScript = bundlerUpdateScript "sqlint";

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
