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
  version = "1.26.1";

  src = fetchFromGitHub {
    owner = "TryGhost";
    repo = "Ghost-CLI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2zyRkPTQBzF+7nmlHPMi4S0BAdmUwIBkwD71y1y7Pn8=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-No+Hkb2ivrCSd0S9L5QxZ8ReX9NANMRITKHFvjzRSuc=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnInstallHook
  ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = ''${placeholder "out"}/bin/ghost'';

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
