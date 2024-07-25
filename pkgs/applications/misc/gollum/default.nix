{ lib, bundlerApp, bundlerUpdateScript, ruby, makeWrapper, git, docutils, nixosTests }:

bundlerApp rec {
  pname = "gollum";
  exes = [ "gollum" ];

  inherit ruby;
  gemdir = ./.;

  nativeBuildInputs = [ makeWrapper ];

  passthru.updateScript = bundlerUpdateScript "gollum";
  passthru.tests.gollum = nixosTests.gollum;

  meta = with lib; {
    description = "Simple, Git-powered wiki with a sweet API and local frontend";
    homepage = "https://github.com/gollum/gollum";
    changelog = "https://github.com/gollum/gollum/blob/HEAD/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen jgillich nicknovitski bbenno ];
    platforms = platforms.unix;
    mainProgram = "gollum";
  };
}
