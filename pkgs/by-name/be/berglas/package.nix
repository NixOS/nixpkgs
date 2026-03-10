{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  berglas,
}:

let
  skipTests = {
    access = "Access";
    create = "Create";
    delete = "Delete";
    list = "List";
    read = "Read";
    replace = "Replace";
    resolver = "Resolve";
    revoke = "Revoke";
    update = "Update";
  };

  skipTestsCommand = builtins.foldl' (
    acc: goFileName:
    let
      testName = builtins.getAttr goFileName skipTests;
    in
    ''
      ${acc}
      substituteInPlace pkg/berglas/${goFileName}_test.go \
        --replace "TestClient_${testName}_storage" "SkipClient_${testName}_storage" \
        --replace "TestClient_${testName}_secretManager" "SkipClient_${testName}_secretManager"
    ''
  ) "" (builtins.attrNames skipTests);
in

buildGoModule (finalAttrs: {
  pname = "berglas";
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "berglas";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-zrNHBlq8ZdsviXws29Dui51HOLJxy5B0OkrRZR8lUdQ=";
  };

  vendorHash = "sha256-tTZQZv5b68AaMLbVtddmlbWerbwvIeYSIX8/Vy0P0HU=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/GoogleCloudPlatform/berglas/v2/internal/version.version=${finalAttrs.version}"
  ];

  postPatch = skipTestsCommand;

  passthru.tests = {
    version = testers.testVersion {
      package = berglas;
    };
  };

  meta = {
    description = "Tool for managing secrets on Google Cloud";
    homepage = "https://github.com/GoogleCloudPlatform/berglas";
    license = lib.licenses.asl20;
    mainProgram = "berglas";
  };
})
