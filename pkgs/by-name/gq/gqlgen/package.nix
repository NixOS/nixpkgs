{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

let
  version = "0.17.90";
in
buildGoModule {
  pname = "gqlgen";
  inherit version;

  src = fetchFromGitHub {
    owner = "99designs";
    repo = "gqlgen";
    tag = "v${version}";
    hash = "sha256-kDr/CCLLuXApfMaiH9T8DoQxxDfSB+gZ8ntwIeG69n4=";
  };

  vendorHash = "sha256-4lc3dR+d3CY6SV3nd9fqt/j4satS0xY08ebSDOjeBuQ=";

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
