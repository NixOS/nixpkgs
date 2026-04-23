{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-04-14";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "3a82969c169b9d71b51e74fe8841d1f04326725d";
    hash = "sha256-8/wgdlM4US5R6xOYFD4uP6gEeRfJsjDwwCz3BIUpoFI=";
  };

  npmDepsHash = "sha256-+3eXdiM0Nll7V6EnDXq88rBjRkPN6GLFASdJ3fMXbq4=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
