{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "0-unstable-2026-02-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "8160b7e315c3b2480749b141f9a24d19323d4282";
    hash = "sha256-0pdbwZa7ikFVKP3OTDufOobIoWUlfWheIC5mSRAF198=";
  };

  npmDepsHash = "sha256-01AvG8BPwFIqqYwqHbbEonA0jMIKhF5wnl/azjfmaPE=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
