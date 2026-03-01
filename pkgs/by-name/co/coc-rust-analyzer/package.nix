{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "5a37db4bf660773b423dc53d4c3abac71783adb7";
    hash = "sha256-yuTLSIt4q6tltxTIT4Uw8jYZ04lN/JZzF9bAw8+l1rs=";
  };

  npmDepsHash = "sha256-dwQs/xayR7lp6ShASUPR1uvrJQ6fQmDjKNVob66j76M=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
