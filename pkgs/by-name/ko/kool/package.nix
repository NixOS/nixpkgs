{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "kool";
  version = "3.6.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kool-dev";
    repo = "kool";
    tag = finalAttrs.version;
    hash = "sha256-81UhlEAk8ZNC/G6tV2g8+VZVVrLJVV6Dji2pjmWIYb8=";
  };

  vendorHash = "sha256-IqUkIf0uk4iUTedTO5xRzjmJwHS+p6apo4E0WEEU6cc=";

  ldflags = [
    "-s"
    "-X=kool-dev/kool/commands.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  meta = {
    description = "From local development to the cloud: development workflow made easy";
    mainProgram = "kool";
    homepage = "https://kool.dev";
    changelog = "https://github.com/kool-dev/kool/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
