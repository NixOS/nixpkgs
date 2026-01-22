{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "code-theme-converter";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "tobiastimm";
    repo = "code-theme-converter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b6b0s6FXyHwoAJnPTaLu9fMQJVpBSqfGBk/KqDbaK9U=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-M8zLr/BPQfS50ZsTwN/YdJAlYUtS9edE/jh+l1wBqR8=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convert any Visual Studio Code Theme to Sublime Text 3 or IntelliJ IDEA";
    homepage = "https://github.com/tobiastimm/code-theme-converter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
