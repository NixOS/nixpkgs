{
  lib,
  stdenv,
  fetchYarnDeps,
  fetchFromGitHub,
  nix-update-script,
  yarnConfigHook,
  yarnBuildHook,
  npmHooks,
  nodejs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "diagnostic-languageserver";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "iamcco";
    repo = "diagnostic-languageserver";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EFkvxMvtA5L6ZiDxrZxGnNAphNn/P3ra6ZrslplScZg=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-T8ppt8EDljtMhGp9i0VleU2Nw3tJexE2ufT6C4EtAz0=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    npmHooks.npmInstallHook
    nodejs
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "General purpose Language Server that integrate with linter to support diagnostic features";
    homepage = "https://github.com/iamcco/diagnostic-languageserver";
    changelog = "https://github.com/iamcco/diagnostic-languageserver/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "diagnostic-languageserver";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
