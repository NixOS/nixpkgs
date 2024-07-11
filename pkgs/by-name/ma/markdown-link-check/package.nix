{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "markdown-link-check";
  version = "3.12.2";

  src = fetchFromGitHub {
    owner = "tcort";
    repo = "markdown-link-check";
    rev = "v${version}";
    hash = "sha256-xeqvKPIJUDNEX9LdXpxoA7ECjGlfp/wwlCw/USZN47c=";
  };

  npmDepsHash = "sha256-J11NJRmXg2tj5BqGSQ8bMRJQUOCOZ9dEfa4Gzrf38t4=";

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
