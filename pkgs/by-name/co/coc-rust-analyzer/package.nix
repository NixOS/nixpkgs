{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "6c1efb649ac338692a65b7960e012ca7cb9ad233";
    hash = "sha256-5k+emMLI6S/YnD3uCDb5tXTYpi95h9E9aCLYfKcO7R8=";
  };

  npmDepsHash = "sha256-5stbU1HxF6R9/afL/CQsRgKedwudUIyeVuyr/wGrApY=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
