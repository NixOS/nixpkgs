{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "js-beautify";
  version = "1.15.4";

  src = fetchFromGitHub {
    owner = "beautifier";
    repo = "js-beautify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7heFAt8ArwBox0R2UFAYyzqyARPLnVtlWmPr0txuxOM=";
  };

  dontNpmBuild = true;

  preBuild = ''
    patchShebangs ./*

    substituteInPlace Makefile \
      --replace-fail "/bin/bash" "bash" \
      --replace-fail "\$(SCRIPT_DIR)/node" "${nodejs}/bin/node" \
      --replace-fail "\$(SCRIPT_DIR)/npm" "${nodejs}/bin/npm"
  '';

  buildPhase = ''
    runHook preBuild
    make js
    runHook postBuild
  '';

  npmDepsHash = "sha256-Tr8kYawvPBt+jC7SW8dnKJVWynQyOpKbRD8yd+qbvIs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/beautifier/js-beautify/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Beautifier for javascript";
    homepage = "https://beautifier.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "js-beautify";
  };
})
