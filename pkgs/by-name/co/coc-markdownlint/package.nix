{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2026-06-17";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "56458cb4ffe81f70e23fafef276dc5eaf8e74061";
    hash = "sha256-FUWJoT8h/Hz8cOUY71TLDYCsWXPxWdT0NNdrhryOlWA=";
  };

  npmDepsHash = "sha256-MuWfnvRWJXEnIa46WBrnhqKHzPe0TAOWuBOMK3XsxcM=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
