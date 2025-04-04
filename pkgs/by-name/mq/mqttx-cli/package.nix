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
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "MQTTX";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kxK/c1tOwK9hCxX19um0z1MWBZQOwADYEh4xEqJNgWI=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/cli/yarn.lock";
    hash = "sha256-vwPwSE6adxM1gkdsJBq3LH2eXze9yXADvnM90LsKjjo=";
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
