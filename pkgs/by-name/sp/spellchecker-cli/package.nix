{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "spellchecker-cli";
  version = "7.0.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tbroadley";
    repo = "spellchecker-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4rKUxXsZKsRDhMV0HL39yQyVNI0negCg97KsI+77oI4=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-GWIjk8eV2yYwsAfe7IY2mjO/dk9mb4vXEOvp68y4eMk=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  yarnBuildScript = "prepack";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A command-line tool for spellchecking files";
    homepage = "https://www.npmjs.com/package/spellchecker-cli";
    mainProgram = "spellchecker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
})
