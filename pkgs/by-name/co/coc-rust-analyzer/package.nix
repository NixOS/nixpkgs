{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2025-11-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "6cc74fcaed6b011b98e9f8483fb608dff53147be";
    hash = "sha256-2XSx4eR9GgMbWY+IOEKuhCAVesxoZbh/KsLr0It0Cks=";
  };

  npmDepsHash = "sha256-94kuqDNsCcPuvTVeprEdjNOPw8pdpDp3IOvuoKdSEgU=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
