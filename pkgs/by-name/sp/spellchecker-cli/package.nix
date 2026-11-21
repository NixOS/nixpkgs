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
  version = "7.0.6";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tbroadley";
    repo = "spellchecker-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/kes+UOXmuwfDKkPQAMZ+06n+kCEkypysrjfcQyw1nA=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-Jv9+4rB9vql+juEz4MnjyY8xNyHOg735EZUvBnKCc6w=";
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
