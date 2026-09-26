{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "markdown-link-check";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "tcort";
    repo = "markdown-link-check";
    rev = "v${version}";
    hash = "sha256-lnyCpDtyXWzlLBDLIXEEQg/tMMs8jIeTJdW7I6LCg9w=";
  };

  npmDepsHash = "sha256-cThGNjM9Jpy281CCpfFOubImrYnMiFp/kljp1mmA1p8=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Checks all of the hyperlinks in a markdown text to determine if they are alive or dead";
    mainProgram = "markdown-link-check";
    homepage = "https://github.com/tcort/markdown-link-check";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
