{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarnConfigHook,
  yarnInstallHook,
  yarnBuildHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ember-language-server";
  version = "2.30.5";

  src = fetchFromGitHub {
    owner = "ember-tooling";
    repo = "ember-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/6j71pBmZor7C1u9BkptwwQonh6ZWoLmMDCMOGCpMik=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-vWCG+FDf6XTNrgqOQGMnE6xNZ5A8PU5DA+FcTLLurIg=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodejs
  ];

  yarnBuildScript = "compile";

  postInstall = ''
    ln -s $out/bin/@ember-tooling/ember-language-server $out/bin/ember-language-server
  '';

  meta = {
    description = "Language Server Protocol implementation for Ember.js projects";
    homepage = "https://github.com/ember-tooling/ember-language-server";
    changelog = "https://github.com/ember-tooling/ember-language-server/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ThaoTranLePhuong ];
    mainProgram = "ember-language-server";
  };
})
