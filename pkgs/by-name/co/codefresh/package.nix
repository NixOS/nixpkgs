{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnInstallHook,
  nodejs,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "codefresh";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "codefresh-io";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8jSLZ9aWgQmQ0DYqKVaTi9JNQVbG7htLoLzkew8TLwo=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-FZd/dSvb69YU41djXdGg7KI5ocgYfpOHXOjfKAg36/w=";
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
    description = "CLI tool to interact with Codefresh services";
    homepage = "https://github.com/codefresh-io/cli";
    license = lib.licenses.mit;
    mainProgram = "codefresh";
    maintainers = [
      lib.maintainers.burdzwastaken
      lib.maintainers.takac
    ];
  };
})
