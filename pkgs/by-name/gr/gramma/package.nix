{
  lib,
  stdenvNoCC,
  fetchYarnDeps,
  fetchFromGitHub,
  yarnConfigHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gramma";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "caderek";
    repo = "gramma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gfBwKpsttdhjD/Opn8251qskURpwLX2S5NSbpwP3hFg=";
  };

  postPatch = ''
    # Set a script name to avoid yargs using cli.js as $0
    substituteInPlace src/cli.js \
      --replace-fail '.demandCommand()' '.demandCommand().scriptName("gramma")'
  '';

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-FuR6wUhAaej/vMgjAlICMEj1pPf+7PFrdu2lTFshIkg=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnInstallHook
    nodejs
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line grammar checker";
    homepage = "https://caderek.github.io/gramma/";
    changelog = "https://github.com/caderek/gramma/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    mainProgram = "gramma";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
