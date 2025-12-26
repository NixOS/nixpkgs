{
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  mqttx-cli,
  nodejs,
  stdenv,
  testers,
  yarnConfigHook,
  yarnInstallHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mqttx-cli";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "MQTTX";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aUxhCUx89Qrqkv0zvgMZhC6SUQlxFoJs2elYtUlMio4=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/cli/yarn.lock";
    hash = "sha256-bhqZLZRRAgsvxo2uAS7x77b5OtGn6x/M2tM72UI1Ayc=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnInstallHook
  ];

  preConfigure = ''
    cd cli
  '';

  # Using custom build script instead of `yarnBuildHook`
  # because it needs `--ignore-engines` before `build`.
  buildPhase = ''
    runHook preBuild
    yarn --offline --ignore-engines build
    runHook postBuild
  '';

  postInstall = ''
    # rename binary so it does not conflict with the desktop app
    mv $out/bin/mqttx $out/bin/mqttx-cli
  '';

  passthru.tests.version = testers.testVersion { package = mqttx-cli; };

  meta = {
    description = "MQTTX Command Line Tools";
    homepage = "https://mqttx.app/";
    changelog = "https://mqttx.app/changelogs/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    mainProgram = "mqttx-cli";
  };
})
