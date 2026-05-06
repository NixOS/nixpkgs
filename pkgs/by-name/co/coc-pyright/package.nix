{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "0-unstable-2026-05-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "114e44fc855a0047657c8d14ccc162d5a024cd10";
    hash = "sha256-+WjGVcqMyvFVpEkVYx84IZjbDu7T3Iqkr92CgYuIYGk=";
  };

  npmDepsHash = "sha256-ZDKcAxOWjk8EzRyXSrY85w5+LjugKahoiM1cXNUMEuM=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
