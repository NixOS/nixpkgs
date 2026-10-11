{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2026-10-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "d935e0f54f937e4e996411866526d908fb516aec";
    hash = "sha256-g6e37cxFQVjYgI84tC0jQn2Qe3syCdg4G4JMD0fnNBk=";
  };

  npmDepsHash = "sha256-nFq0OwIRl2nNAXjGGzybJsB2g6v/O2VTCDwJUPYwwoI=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
