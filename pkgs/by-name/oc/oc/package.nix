{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  nodejsInstallExecutables,
  nodejsInstallManuals,
  npmHooks,
  fetchNpmDeps,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oc";
  version = "0.5.10";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "only-cli";
    repo = "oc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4kTmHm0i22WfAUFDGMYFmibS/eUwMcaeubi3bOjzrn4=";
  };

  nativeBuildInputs = [
    nodejs
    nodejsInstallExecutables
    nodejsInstallManuals
    npmHooks.npmConfigHook
    npmHooks.npmBuildHook
    npmHooks.npmInstallHook
  ];

  npmBuildScript = "build";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-yx9SAESUBqm6GrSFUJnFqQE8pMmPsFgg+56/F5ZGpXU=";
  };

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Turn any website into a compact CLI tailored for AI agents. Browse the web in hundreds of tokens, not tens of thousands";
    homepage = "https://github.com/only-cli/oc";
    changelog = "https://github.com/only-cli/oc/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "oc";
    platforms = lib.platforms.all;
  };
})
