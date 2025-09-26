{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchurl,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "node-core-utils";
  version = "5.15.0";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "node-core-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yY3EGSBdMpvUIq8UgeEcAm1RIaaNtZxCVp6TlycYjoY=";
  };

  npmDepsHash = "sha256-VIkJHEGlJqweNVkx3WfLMiDOQRSPtwpJBfJ3vKHv4YM=";

  dontNpmBuild = true;
  dontNpmPrune = true;
  npmInstallFlags = [ "--omit=dev" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/git-node";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "CLI tools for Node.js Core collaborators";
    homepage = "https://github.com/nodejs/node-core-utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
  };
})
