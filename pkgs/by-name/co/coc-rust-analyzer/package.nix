{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-04-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "569c6c56e815ae29ad7873b472ebb750c19d0d38";
    hash = "sha256-4IZhCQl+iKChGaT0ghn5MnB+h6U5DJSa7YgPDoObiBg=";
  };

  npmDepsHash = "sha256-B/EBAhwEEqLgGshK3Fw7nG7Mv9kk0v4ClLglLhooYBM=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
