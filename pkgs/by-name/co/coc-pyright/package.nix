{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "0-unstable-2025-11-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "9ac99c71ea92810b532283b690f6771601c74ff2";
    hash = "sha256-nADl29GiApBZMKW0yQ9QVWBiduaGNXO8Cm4XxZmNfMQ=";
  };

  npmDepsHash = "sha256-+9bf/3b8vZZgkiC2DA15js9X5PFHzK9dltTA9XJt+GE=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
