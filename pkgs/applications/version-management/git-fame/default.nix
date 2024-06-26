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

  meta = with lib; {
    description = ''
      A command-line tool that helps you summarize and pretty-print collaborators based on contributions
    '';
    homepage = "http://oleander.io/git-fame-rb";
    license = licenses.mit;
    maintainers = with maintainers; [
      expipiplus1
      nicknovitski
    ];
    platforms = platforms.unix;
    mainProgram = "git-fame";
  };
}
