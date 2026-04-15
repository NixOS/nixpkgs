{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-04-09";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "561aea31f1e263c8386ab7e09b7ffa95e64cd351";
    hash = "sha256-Ee/5nkPdQBXwt5jQOMN+2/nHRwk33HigeY/L0NpTLAY=";
  };

  npmDepsHash = "sha256-+3eXdiM0Nll7V6EnDXq88rBjRkPN6GLFASdJ3fMXbq4=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
