{ lib, stdenv, fetchFromGitHub, fetchYarnDeps, yarnConfigHook, yarnBuildHook, yarnInstallHook, nodejs, testers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "all-contributors-cli";
  version = "6.26.1";

  src = fetchFromGitHub {
    owner = "all-contributors";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uffesAxJjjFP7VrsKJtXUVnWiRNAUY9Jolm8kKmICuA=";
  };

  postPatch = ''
    cp ${./yarn.lock} yarn.lock
    chmod +w yarn.lock
  '';

  offlineCache = fetchYarnDeps {
    yarnLock = "${./yarn.lock}";
    hash = "sha256-k/86x9xZWkFjwwD+flKiHqa26nLBZAfUibUOyPZ0ajs=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "all-contributors --version";
  };

  meta = {
    changelog = "https://github.com/all-contributors/cli/releases/tag/v${finalAttrs.version}";
    description = "Tool to help automate adding contributor acknowledgements according to the all-contributors specification ✨";
    homepage = "https://github.com/all-contributors/cli";
    license = lib.licenses.mit;
    mainProgram = "all-contributors";
    maintainers = [ lib.maintainers.mahtaran ];
  };
})
