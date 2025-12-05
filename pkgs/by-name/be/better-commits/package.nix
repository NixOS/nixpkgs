{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "better-commits";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "Everduin94";
    repo = "better-commits";
    tag = "v${version}";
    hash = "sha256-tkGLlvOldKKpoFswo1UzUhNJHstKISRpCDGFrL/W7ZI=";
  };

  npmDepsHash = "sha256-lPJ50DYnANJZ3IowE3kOCyAx9peq7Donh72jk1eQnBs=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "CLI for creating better commits following the conventional commits specification";
    homepage = "https://github.com/Everduin94/better-commits";
    license = licenses.mit;
    maintainers = [ maintainers.ilarvne ];
    platforms = platforms.unix;
    mainProgram = "better-commits";
  };
}
