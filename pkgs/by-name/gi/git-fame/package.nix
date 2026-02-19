{
  lib,
  bundlerEnv,
  ruby,
  bundlerUpdateScript,
}:

bundlerEnv {
  inherit ruby;

  pname = "git_fame";

  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "git-fame";

  meta = {
    description = "Command-line tool that helps you summarize and pretty-print collaborators based on contributions";
    homepage = "http://oleander.io/git-fame-rb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nicknovitski
      matthiasbeyer
    ];
    platforms = lib.platforms.unix;
    mainProgram = "git-fame";
  };
}
