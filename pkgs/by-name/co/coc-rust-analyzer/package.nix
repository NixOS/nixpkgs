{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-06-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "c21b850ab4f2c9fc80840450ece29f9abc4e2325";
    hash = "sha256-2ntLQ2qBqZZ9vPJHQR0JzqR8wUVRCLRGTEu3Q4Is2Jo=";
  };

  npmDepsHash = "sha256-4AdpOBXLqWzFQrI7MyWdEqkiE8BuxOV+SmHcFMKlkBk=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
