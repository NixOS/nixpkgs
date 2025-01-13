{
  fetchFromGitHub,
  fetchYarnDeps,
  fetchpatch,
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
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "MQTTX";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-IPIiSav6MPJmzetBgVw9fLGPjJ+JKS3oWMEfCJmEY84=";
  };

  patches = [
    # moves @faker-js/faker from devDependencies to dependencies
    # because the final package depends on it
    # https://github.com/emqx/MQTTX/pull/1801
    (fetchpatch {
      url = "https://github.com/emqx/MQTTX/commit/3d89c3a08477e9e2b5d83f2a222ceaa8c08e50ce.patch";
      hash = "sha256-Rd6YpGHsvAYD7/XCJq6dgvGeKfOiLh7IUQFr/AQz0mY=";
    })
  ];

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
