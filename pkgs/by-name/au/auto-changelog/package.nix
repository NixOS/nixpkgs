{
  lib,
  stdenv,
  fetchYarnDeps,
  fetchFromGitHub,
  yarnConfigHook,
  npmHooks,
  nodejs,
  git,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "auto-changelog";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "cookpete";
    repo = "auto-changelog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qgJ/TVyViMhISt/EfCWV7XWQLXKTeZalGHFG905Ma5I=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-rP/Xt0txwfEUmGZ0CyHXSEG9zSMtv8wr5M2Na+6PbyQ=";
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

  meta = {
    description = "Command line tool for generating a changelog from git tags and commit history";
    homepage = "https://github.com/cookpete/auto-changelog";
    changelog = "https://github.com/cookpete/auto-changelog/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "auto-changelog";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
