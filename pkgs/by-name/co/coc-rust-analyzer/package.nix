{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-07-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "056c78eb619bdf985d4414cbf73abfc5226d5c04";
    hash = "sha256-1WhU2GYUU2l3tKpb5F6VxY61HPOHqtuS6hbI+upCmH8=";
  };

  npmDepsHash = "sha256-ifDAM08pfdbqPl9G5s5cx8hGzldNuVc0DcXDyCGgkkI=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
