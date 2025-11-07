{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2025-11-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "4e507d516ccb0e0287c95d909db85676d786e9bd";
    hash = "sha256-fNUmrwjCiMYZHXkI4RPn4BMRxiWW+BoVEvaSMIsEMeQ=";
  };

  npmDepsHash = "sha256-JMXeWQZMYkhUqE5DdYBRRhyHDAqr9VkKATRQE6eOGys=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
