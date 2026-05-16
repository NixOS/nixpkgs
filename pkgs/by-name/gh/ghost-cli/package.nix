{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnInstallHook,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ghost-cli";
  version = "1.28.6";

  src = fetchFromGitHub {
    owner = "TryGhost";
    repo = "Ghost-CLI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GUdo2qn+5YOefCSHlH+jv+gSZWlT8POzQlaN0+Yxuhk=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-B39MyCn4P8iqT/y2wPeHKJgYWzgB4I81usmzC0PH3qU=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnInstallHook
  ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/ghost";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI Tool for installing & updating Ghost";
    mainProgram = "ghost";
    homepage = "https://ghost.org/docs/ghost-cli/";
    changelog = "https://github.com/TryGhost/Ghost-CLI/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cything ];
  };
})
