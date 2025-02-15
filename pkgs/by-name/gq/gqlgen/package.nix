{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

let
  version = "0.17.64";
in
buildGoModule {
  pname = "gqlgen";
  inherit version;

  src = fetchFromGitHub {
    owner = "99designs";
    repo = "gqlgen";
    tag = "v${version}";
    hash = "sha256-JzXjUOhj49rp+aALfP48mRkySObd7z5qaHH6Na649+4=";
  };

  vendorHash = "sha256-p285G/EfkrLrmbEc10J/QXIn6Hi3KIXH0f+BYeFpE4s=";

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
