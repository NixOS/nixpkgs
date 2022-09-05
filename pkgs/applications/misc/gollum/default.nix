{ lib, bundlerApp, bundlerUpdateScript, ruby, makeWrapper, git, docutils }:

bundlerApp rec {
  pname = "gollum";
  exes = [ "gollum" ];

  inherit ruby;
  gemdir = ./.;

  nativeBuildInputs = [ makeWrapper ];

  passthru.updateScript = bundlerUpdateScript "gollum";

  meta = with lib; {
    description = "A simple, Git-powered wiki with a sweet API and local frontend";
    homepage = "https://github.com/gollum/gollum";
    changelog = "https://github.com/gollum/gollum/blob/HEAD/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen jgillich nicknovitski bbenno ];
    platforms = platforms.unix;
  };
}
