{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-06-16";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "832db4c7c99b526bf3608ea40a5a904cae77b691";
    hash = "sha256-bf3pA4JOCN+BhtIFIHBplHkLqvtdwYKZObrdkw+2v4E=";
  };

  npmDepsHash = "sha256-5yOJwuqeW9tyXRmp/G1gEsv4h2OIr3QFYCXZC8pbJQI=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
}
