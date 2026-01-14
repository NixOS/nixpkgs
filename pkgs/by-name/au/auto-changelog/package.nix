{
  lib,
  stdenv,
  fetchYarnDeps,
  fetchFromGitHub,
  yarnConfigHook,
  npmHooks,
  nodejs,
  git,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "auto-changelog";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "cookpete";
    repo = "auto-changelog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ticQpDOQieLaWXfavDKIH0jSenRimp5QYeJy42BjpKw=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-NGQbzogQi0XbeGd7fYNyw0i9Yo9j91CfeTdO7nhq4Yw=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    npmHooks.npmInstallHook
    nodejs
  ];

  doCheck = true;

  nativeCheckInputs = [ git ];

  checkPhase = ''
    runHook preCheck
    yarn --offline run test -i -g 'compileTemplate'
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool for generating a changelog from git tags and commit history";
    homepage = "https://github.com/cookpete/auto-changelog";
    changelog = "https://github.com/cookpete/auto-changelog/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "auto-changelog";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
