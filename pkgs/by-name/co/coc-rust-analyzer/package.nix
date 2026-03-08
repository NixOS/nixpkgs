{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-03-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "6086cb2075cf0c95fe41f225231b0d6e10bdeab7";
    hash = "sha256-o3skzvjnAjdd7uS1UboLbZBXY7qgrwr7XYnVlf+PUpc=";
  };

  npmDepsHash = "sha256-39pOjwZuos4yfOrTZjGyKgB6pTJXO/Oi5jTJzXs0xKg=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
