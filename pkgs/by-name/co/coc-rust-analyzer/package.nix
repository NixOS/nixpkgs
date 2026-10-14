{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-10-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "3a898ba171e3cf3558b26f79d6bb2361faf2d9eb";
    hash = "sha256-eNd4LbQJUKkyj2qeUGesYFJ1VPNayl8oD57k3Eu7z1Y=";
  };

  npmDepsHash = "sha256-ut9hw6COc/amICmtLuos+Q8VOmi92IGcl8/wPykqVmU=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
