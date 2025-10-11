{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  npmHooks,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "prettier-plugin-sql-cst";
  version = "0.12.2";
  passthru.updateScript = nix-update-script { };

  src = fetchFromGitHub {
    owner = "nene";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-00d5cm6upvUga46r75r5GNQ1aFgNwC4w125kAjJcH2w=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-U939eT+3LQDDcj843K9qV1CtxWdslS/PtsjwYvYdgvk=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    # Needed for executing package.json scripts
    nodejs
    npmHooks.npmInstallHook
  ];

  # Causes the build to fail due to dependencies not available offline
  dontNpmPrune = true;

  meta = {
    description = "Prettier SQL plugin that uses sql-parser-cst";
    homepage = "https://github.com/nene/prettier-plugin-sql-cst?tab=readme-ov-file";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ibrokemypie ];
    mainProgram = "lib/node_modules/prettier-plugin-sql-cst/dist/index.js ";
  };
})
