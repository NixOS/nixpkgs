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
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "node-core-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cnnzFa8RK7HSuOcbW1Cwz+gQ1+jbcOYD844F2hXlSBI=";
  };

  npmDepsHash = "sha256-K6wY8NmzrE/uCyK/EAc8oAiO/0jmYYHhgcIO37AANO0=";

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
