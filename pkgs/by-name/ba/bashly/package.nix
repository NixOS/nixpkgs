{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "bashly";

  gemdir = ./.;
  exes = [ "bashly" ];

  passthru.updateScript = bundlerUpdateScript "bashly";

  meta = {
    description = "Bash command line framework and CLI generator";
    homepage = "https://github.com/DannyBen/bashly";
    license = lib.licenses.mit;
    mainProgram = "bashly";
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.unix;
  };
}
