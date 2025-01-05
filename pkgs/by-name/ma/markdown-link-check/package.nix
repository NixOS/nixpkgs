{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "markdown-link-check";
  version = "3.13.6";

  src = fetchFromGitHub {
    owner = "tcort";
    repo = "markdown-link-check";
    rev = "v${version}";
    hash = "sha256-UuzfIJL3nHIbGFQrs9ya+QiS/sM0z1GCHbJGLQBN5pE=";
  };

  npmDepsHash = "sha256-Lxywr3M/4+DwVWxkWZHHn02K7RNWSI5LyMm12lyZT8w=";

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
