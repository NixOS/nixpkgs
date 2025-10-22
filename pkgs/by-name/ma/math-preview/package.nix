{
  lib,
  nix-update-script,
  fetchFromGitLab,
  buildNpmPackage,
  nodejs_20,
}:

let
  nodejs = nodejs_20;
in

buildNpmPackage rec {
  pname = "math-preview";
  version = "5.1.1";
  inherit nodejs;

  src = fetchFromGitLab {
    owner = "matsievskiysv";
    repo = "math-preview";
    rev = "v${version}";
    hash = "sha256-P3TZ/D6D2PvwPV6alSrDEQujzgI8DhK4VOuCC0BCIFo=";
  };

  npmDepsHash = "sha256-GAPhG3haM9UNdj6tCz8I4j7v6rvNbatdu7NjCeENj3s=";
  dontNpmBuild = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Emacs preview math inline";
    mainProgram = "math-preview";
    license = licenses.gpl3Plus;
    homepage = "https://gitlab.com/matsievskiysv/math-preview";
    maintainers = with maintainers; [ renesat ];
    inherit (nodejs.meta) platforms;
  };
}
