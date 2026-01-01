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

<<<<<<< HEAD
  meta = {
    description = "Command-line tool that helps you summarize and pretty-print collaborators based on contributions";
    homepage = "http://oleander.io/git-fame-rb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nicknovitski
      matthiasbeyer
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Command-line tool that helps you summarize and pretty-print collaborators based on contributions";
    homepage = "http://oleander.io/git-fame-rb";
    license = licenses.mit;
    maintainers = with maintainers; [
      nicknovitski
      matthiasbeyer
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "git-fame";
  };
}
