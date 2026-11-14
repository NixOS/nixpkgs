{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "kool";
  version = "3.8.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kool-dev";
    repo = "kool";
    tag = finalAttrs.version;
    hash = "sha256-Nc3iwoirIHvbSPDGm7Y9mCbeurDLnCTjUXr4gob9l0I=";
  };

  vendorHash = "sha256-G453DRSMh9fT4SiFtl3PgmT2X8WzGJ0FNRYY4kmV3r0=";

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
