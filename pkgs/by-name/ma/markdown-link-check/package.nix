{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "markdown-link-check";
  version = "3.14.1";

  src = fetchFromGitHub {
    owner = "tcort";
    repo = "markdown-link-check";
    rev = "v${version}";
    hash = "sha256-g0264lQGIcurm+qnVFu2sZw11sSzoyAvhALDvXkrfts=";
  };

  npmDepsHash = "sha256-Qw7s/IyPjOkgDLWSMSnMekRjBs9Hg/x/9JKVHqz+W6E=";

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
