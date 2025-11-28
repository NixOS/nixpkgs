{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2025-11-25";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "8bd84ab1c2b436a2e9fadf059b5785f43e877c1e";
    hash = "sha256-R9IQuoNGCqodbAkPnQLHi8sPzXvT3x+K9mt7apywips=";
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
