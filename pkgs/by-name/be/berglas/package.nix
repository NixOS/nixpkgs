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
  version = "2.0.9";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "berglas";
    rev = "v${version}";
    sha256 = "sha256-VlVqbFaNT66THEZ79ob1hKq2rywSkb1V3Xo1U+ZGeBc=";
  };

  vendorHash = "sha256-XEZ0sLvC7PwNarYa9xdKUOguJKEK50vWW0g2jnWJMu0=";

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

  meta = {
    description = "Tool for managing secrets on Google Cloud";
    homepage = "https://github.com/GoogleCloudPlatform/berglas";
    license = lib.licenses.asl20;
    mainProgram = "berglas";
  };
}
