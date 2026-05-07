{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2026-04-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "9a92eef6adbd6ba7b1afe50bd9a3c82b94902c51";
    hash = "sha256-5pfsaZFA1OYwREB3FqyUQY4D47dKH22pQV8dBgPiipo=";
  };

  npmDepsHash = "sha256-J6gYA3eP2PWK3kesJDL5tqHOY/j2PoC+uhVxpeYVnsk=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
