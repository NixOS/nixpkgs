{
  lib,
  buildNpmPackage,
  fetchFromCodeberg,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "librejs-cmd";
  version = "0-unstable-2026-07-27";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromCodeberg {
    owner = "librejs";
    repo = "librejs-cmd";
    rev = "6a9ffd92054cacf7cb298146d44cc8a0b4f501cc";
    hash = "sha256-1L5zmFeOYg5RiGU/SRi7pOeh2cikQPTak8u1wyYjhs8=";
  };

  npmDepsHash = "sha256-2FQs7FGr1ZXgbwiqISv7ZYOcq9VMSLQkY9P3+jPEcgE=";
  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line interface for librejs";
    homepage = "https://codeberg.org/librejs/librejs-cmd";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "librejs-cmd";
  };
})
