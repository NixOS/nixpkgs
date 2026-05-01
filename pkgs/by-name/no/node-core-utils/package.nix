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
  version = "6.3.2";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "node-core-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i9Y4XtvQjqHmbo5yzGmOT7d0wPf4xEt2ta32AOwJT/g=";
  };

  npmDepsHash = "sha256-FQbFzentyRARuB2fpRZGDfMJHkrgvyUGovaOgpE0z5Y=";

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
