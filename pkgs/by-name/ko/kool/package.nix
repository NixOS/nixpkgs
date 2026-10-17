{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "kool";
  version = "3.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kool-dev";
    repo = "kool";
    tag = finalAttrs.version;
    hash = "sha256-8E/1GGDXwGlSEVPjpel0kIuVhE8pUeqmRpQjGi+sCR0=";
  };

  vendorHash = "sha256-uwfZU7jj1o7b2o1HmkxZjPgYXsN3yQKUYQfMVqzqUmM=";

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
