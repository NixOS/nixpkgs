{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "js-beautify";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "beautifier";
    repo = "js-beautify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qp9ZYHEdWgjTwvnPScCQOId/SQU/d1z+75UY61Kj8kc=";
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

  npmDepsHash = "sha256-TyercBuuaZWVg+F89s90eOvDCMloDWPMnUQwoPG4Ixg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/beautifier/js-beautify/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Beautifier for javascript";
    homepage = "https://beautifier.io/";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "js-beautify";
  };
})
