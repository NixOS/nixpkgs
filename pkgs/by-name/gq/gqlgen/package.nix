{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

let
  version = "0.17.91";
in
buildGoModule {
  pname = "gqlgen";
  inherit version;

  src = fetchFromGitHub {
    owner = "99designs";
    repo = "gqlgen";
    tag = "v${version}";
    hash = "sha256-z4VCso3IxV8R9ov9qeyO9UH7DqExe1ybJF6eTaV7odI=";
  };

  vendorHash = "sha256-jOwBUeDPOctjeJGIEH7TxcNWX4jF/j1DyNk+FKrLQMQ=";

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
    description = "Go generate based GraphQL server library";
    license = lib.licenses.mit;
    mainProgram = "gqlgen";
    maintainers = with lib.maintainers; [ skowalak ];
  };
}
