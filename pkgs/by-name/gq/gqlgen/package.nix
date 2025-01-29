{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

let
  version = "0.17.63";
in
buildGoModule {
  pname = "gqlgen";
  inherit version;

  src = fetchFromGitHub {
    owner = "99designs";
    repo = "gqlgen";
    tag = "v${version}";
    hash = "sha256-J9+pleHdbQMHP/Aq9Pl6ise6PDvRqxQ72Iq7SNxgMws=";
  };

  vendorHash = "sha256-hPUWYOfCx+kW2dJsjkCE/7bwofnGdQbDTvfZ877/pCk=";

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
