{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-06-09";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "cadaeed1edf1bc289c616d21f5818cf835ae45b2";
    hash = "sha256-eo+3K40JhktADVN2SWJg8AQAXBndx6u2L56ZXGbhqdE=";
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
