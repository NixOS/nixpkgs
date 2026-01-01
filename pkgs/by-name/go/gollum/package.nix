{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  ruby,
  makeWrapper,
  nixosTests,
}:

bundlerApp {
  pname = "gollum";
  exes = [ "gollum" ];

  inherit ruby;
  gemdir = ./.;

  nativeBuildInputs = [ makeWrapper ];

  passthru.updateScript = bundlerUpdateScript "gollum";
  passthru.tests.gollum = nixosTests.gollum;

<<<<<<< HEAD
  meta = {
    description = "Simple, Git-powered wiki with a sweet API and local frontend";
    homepage = "https://github.com/gollum/gollum";
    changelog = "https://github.com/gollum/gollum/blob/HEAD/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Simple, Git-powered wiki with a sweet API and local frontend";
    homepage = "https://github.com/gollum/gollum";
    changelog = "https://github.com/gollum/gollum/blob/HEAD/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      erictapen
      jgillich
      nicknovitski
      bbenno
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "gollum";
  };
}
