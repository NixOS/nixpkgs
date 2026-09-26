{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-09-19";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "6536aae37263c43d1736f622d371124b7a9fe86d";
    hash = "sha256-iY1bvS8mCrldkms0wRvXAcFzzJwGomKqtUBpqV7KJl4=";
  };

  npmDepsHash = "sha256-9xJuiu/LnMIbPRgDog2Xl0DD6Y9O39AzhinrCYguToc=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
