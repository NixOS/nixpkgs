{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-prettier";
  version = "11.0.1";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-prettier";
    tag = finalAttrs.version;
    hash = "sha256-QD31kF7HIsh7C6ykt+x7utLEmN7msprGstoRa3PC7j8=";
  };

  npmDepsHash = "sha256-vKkW3PbeN3KtJHLvr0HBMiDx9XZgyBZD40gENDnoOSs=";

  npmBuildScript = "prepare";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prettier extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-prettier";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
