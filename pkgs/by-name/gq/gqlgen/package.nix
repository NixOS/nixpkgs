{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

let
<<<<<<< HEAD
  version = "0.17.85";
=======
  version = "0.17.84";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildGoModule {
  pname = "gqlgen";
  inherit version;

  src = fetchFromGitHub {
    owner = "99designs";
    repo = "gqlgen";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-U2qbOjWUE1MfrMJTVaB59Osax8B6CKMlk6uqGioVgBk=";
  };

  vendorHash = "sha256-9rBdr1fP5LKioz2c6lAZEdcDnG2JL2CO1VXK5+MwGEs=";
=======
    hash = "sha256-5Bz9iJJfDqzhuQbIbcpqCKTrSy4v8jpmjm8R1nn17R4=";
  };

  vendorHash = "sha256-1837pdV4pnwHjogdZqzBR2Ab3gZNW2stvbwvd6MQoBc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
