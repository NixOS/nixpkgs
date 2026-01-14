{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-haxe";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "vantreeseba";
    repo = "coc-haxe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iveWhxkrX8EaBfh8IwKrTLw1AiGBmNva9G0p3rMwOi8=";
  };

  npmDepsHash = "sha256-1RrhUyICnYDM9qC9dEZLDPQdsFqcu8Nn/enfm+PgM00=";

  npmBuildScript = "prepare";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Haxe language server extension for coc.nvim";
    homepage = "https://github.com/vantreeseba/coc-haxe";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
