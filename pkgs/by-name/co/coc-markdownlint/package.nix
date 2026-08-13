{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2026-08-11";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "aff1a01b4a04319d4dc86401fd0cee289e93a869";
    hash = "sha256-ZascCNQEwcBXTR4Gf3q0Y2Upi/T9eXp5LbK9si87hlE=";
  };

  npmDepsHash = "sha256-icdvkKBWa9lVAORvp7RxudFVxoXUXAIU00E7xrXBqNk=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
