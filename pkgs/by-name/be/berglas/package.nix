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

buildGoModule rec {
  pname = "berglas";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bW8D8g4FPx0i4iPP7Pvm0UpaJFNsECR3kuHEZn8NLx0=";
  };

  vendorHash = "sha256-+ncl/6BJ7J2cby29I1IvkUgbiyDP+co/+Cyyh/V8A1I=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/GoogleCloudPlatform/berglas/v2/internal/version.version=${version}"
  ];

  postPatch = skipTestsCommand;

  passthru.tests = {
    version = testers.testVersion {
      package = berglas;
    };
  };

  meta = with lib; {
    description = "Tool for managing secrets on Google Cloud";
    homepage = "https://github.com/GoogleCloudPlatform/berglas";
    license = licenses.asl20;
    mainProgram = "berglas";
  };
}
