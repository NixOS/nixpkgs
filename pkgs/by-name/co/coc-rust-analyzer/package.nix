{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-11-05";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "c0da93cce1a258104a6358aa84cc32472338e498";
    hash = "sha256-1OJYCfafE2BDsBDNtVyXGz66tnnnIOl4Hd7aKQs2z5k=";
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
