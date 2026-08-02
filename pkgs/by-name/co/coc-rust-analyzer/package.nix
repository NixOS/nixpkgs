{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-07-21";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "64fad431e66b689df044138c0a1376efc5a931d5";
    hash = "sha256-lKIMR1P6jupSD8+xyEYsW/1BhSUjkO/98oG2ZNQPmIo=";
  };

  npmDepsHash = "sha256-Cu+FgBjARZwQGymnX5kaph5JGVPTYR6P+oO87cePXHA=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
