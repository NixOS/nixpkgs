{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

let
  version = "0.17.67";
in
buildGoModule {
  pname = "gqlgen";
  inherit version;

  src = fetchFromGitHub {
    owner = "99designs";
    repo = "gqlgen";
    tag = "v${version}";
    hash = "sha256-pNxV+8hkTksdOhAB+Z0pRKe1BUCk7zsZq4YaQ41jXkg=";
  };

  vendorHash = "sha256-uxNKI6yQ/oyBlgBHODs6CeTVEfm6PUIPwoTsezZmbRA=";

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  checkFlags = [
    "-skip=^TestGenerate$" # skip tests that want to run `go mod tidy`
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  versionCheckProgramArg = "version";

  meta = {
    homepage = "https://github.com/99designs/gqlgen";
    changelog = "https://github.com/99designs/gqlgen/releases/tag/v${version}";
    description = "go generate based graphql server library";
    license = lib.licenses.mit;
    mainProgram = "gqlgen";
    maintainers = with lib.maintainers; [ skowalak ];
  };
}
