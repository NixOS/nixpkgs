{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "0-unstable-2025-12-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "263919ddd3dce33d15626ed6c6139702839295e0";
    hash = "sha256-tcD4Irq3IRVNFh1rCfvVg1VSbiMtc1bswAKTRmIfo8Y=";
  };

  npmDepsHash = "sha256-LW0twhPlWZLFYSzfzoi9Rg8+EsmkllfasR51YtrcdnQ=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
