{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "674637e97ff14073b09350b41f8737bb95400cf1";
    hash = "sha256-FrrsBvkfyrZZCfTMNxht4+ub9r3gy+zdWXNLGuCWlJA=";
  };

  npmDepsHash = "sha256-h4vCJEZxI7M7xD9e5VdI2JDgRLcGdEO0SNXLrv3E5A8=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
