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
        --replace-fail "TestClient_${testName}_storage" "SkipClient_${testName}_storage" \
        --replace-fail "TestClient_${testName}_secretManager" "SkipClient_${testName}_secretManager"
    ''
  ) "" (builtins.attrNames skipTests);
in

buildGoModule (finalAttrs: {
  pname = "berglas";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "berglas";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-4Y53psmHpe1JmTKfvOS5f0VHCp/GuC4kDWiHWl5ty3Q=";
  };

  vendorHash = "sha256-Bz+4hlT5ZqpDnquGirooyFMG8FNUU2NO60Ih3Et3Y3o=";

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
