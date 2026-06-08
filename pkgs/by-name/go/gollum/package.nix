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

  meta = {
    description = "Simple, Git-powered wiki with a sweet API and local frontend";
    homepage = "https://github.com/gollum/gollum";
    changelog = "https://github.com/gollum/gollum/blob/HEAD/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      erictapen
      jgillich
      nicknovitski
      bbenno
    ];
    platforms = lib.platforms.unix;
    mainProgram = "gollum";
  };
}
