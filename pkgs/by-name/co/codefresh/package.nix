{ lib, stdenv, fetchFromGitHub, fetchYarnDeps, yarnConfigHook, yarnInstallHook, nodejs, testers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "codefresh";
  version = "0.87.3";

  src = fetchFromGitHub {
    owner = "codefresh-io";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SUwt0oWls823EeLxT4CW+LDdsjAtSxxxKkllhMJXCtM=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-tzsHbvoQ59MwE4TYdPweLaAv9r4V8oyTQyvdeyPCsHY=";
  };
  nativeBuildInputs = [
    yarnConfigHook
    yarnInstallHook
    nodejs
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    # codefresh needs to read a config file, this is faked out with a subshell
    command = "codefresh --cfconfig <(echo 'contexts:') version";
  };

  meta = {
    changelog = "https://github.com/codefresh-io/cli/releases/tag/v${finalAttrs.version}";
    description = "Codefresh CLI tool to interact with Codefresh services";
    homepage = "https://github.com/codefresh-io/cli";
    license = lib.licenses.mit;
    mainProgram = "codefresh";
    maintainers = [ lib.maintainers.takac ];
  };
})
