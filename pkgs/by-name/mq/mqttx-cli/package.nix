{
  mkYarnPackage,
  fetchYarnDeps,
  fetchFromGitHub,
  lib,
  testers,
  mqttx-cli,
}:

mkYarnPackage rec {
  pname = "mqttx-cli";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "MQTTX";
    rev = "v${version}";
    hash = "sha256-ge6NpehP/4fEUZMqpDB494ut4OfOEpTZOvQMAX9dB/E=";
  };

  packageJSON = ./package.json;
  yarnLock = "${src}/cli/yarn.lock";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/cli/yarn.lock";
    hash = "sha256-WfMKuMCetbrmja5jq3VvEaD7/Z6Nj+/BY7qZiiR8U6g=";
  };

  preConfigure = ''
    cd cli
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  postInstall = ''
    # remove some devDependencies which are using up storage
    rm -r $out/libexec/mqttx-cli/node_modules/{typescript,@types}
    # rename binary so it does not conflict with the desktop app
    mv $out/bin/mqttx $out/bin/mqttx-cli
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion { package = mqttx-cli; };
  };

  meta = {
    description = "MQTTX Command Line Tools";
    homepage = "https://mqttx.app/";
    changelog = "https://mqttx.app/changelogs/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    mainProgram = "mqttx-cli";
  };
}
