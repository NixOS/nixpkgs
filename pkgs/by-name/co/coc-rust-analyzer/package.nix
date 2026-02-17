{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-02-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "78cef805723355af4a172714915c74529a562cf3";
    hash = "sha256-KivOKm0wJKM9/i8/KsCfrG1O2LBAKk2zMi1/7CevylI=";
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
