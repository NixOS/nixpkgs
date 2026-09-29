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
  version = "7.0.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tbroadley";
    repo = "spellchecker-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+5hg7f8gV5CmRqD7RC/qnRNPkCOsAh65IE5QyQNUv7s=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-lv72SIcf/xcNEEyLP1wgjiL/6Xi2GPMWT74B+MrK1m8=";
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
