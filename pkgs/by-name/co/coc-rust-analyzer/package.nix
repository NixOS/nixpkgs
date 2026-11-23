{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-11-17";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "1f83ef5cfa13b9e0e3e6bcfdc3ee52b00de463a6";
    hash = "sha256-z5wcFL57grDE18LUIvL8C2X7xD4MY1wby3yYHxm94qI=";
  };

  npmDepsHash = "sha256-CLS6NyA2q0PDACqp5N/29PhhrxDb/D4aAAWFgmRW/co=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
