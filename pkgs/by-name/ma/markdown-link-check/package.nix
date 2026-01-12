{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "markdown-link-check";
  version = "3.14.2";

  src = fetchFromGitHub {
    owner = "tcort";
    repo = "markdown-link-check";
    rev = "v${version}";
    hash = "sha256-5keyuUEp+JlS19YZJvRNjx30qfJBYBzf9fDOO7LKVb4=";
  };

  npmDepsHash = "sha256-MBJZJsJ2Q0th0QBeDD7yJnv42Pot82IicD06qz1DPkw=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Checks all of the hyperlinks in a markdown text to determine if they are alive or dead";
    mainProgram = "markdown-link-check";
    homepage = "https://github.com/tcort/markdown-link-check";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
