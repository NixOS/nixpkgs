{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-08-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "a61a0231ca424760a5c5a7498e52dfb16132d386";
    hash = "sha256-zMYOrdnpSI3uQuO3qb+SPcAw3lVhBPev5LXcUJ6cw6s=";
  };

  npmDepsHash = "sha256-Td6TdFxrWTZE+2NKxTABChAB/YaN8MjL/uemda+AYfc=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
