{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "0-unstable-2026-08-07";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "66eca10f2575c051f1bc84386220b1df9427175b";
    hash = "sha256-VJc9ss7ARsk3qUiW6Ox11ustjKzVamjhrTeAdB7VmaA=";
  };

  npmDepsHash = "sha256-SNPtiVwnfDNMrBUBAzRK6X1oFN5khw1N1SOmmCmzOgs=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
