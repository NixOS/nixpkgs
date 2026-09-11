{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-08-11";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "f61f4f712c9902ea6362c73e25e70ec552deb0e5";
    hash = "sha256-Hm3TGc/6DPEqGwZ1KIHFlCP0BipJCoaKBg05cnjVv04=";
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
