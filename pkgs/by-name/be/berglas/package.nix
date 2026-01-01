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
<<<<<<< HEAD
  version = "2.0.9";
=======
  version = "2.0.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "berglas";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-VlVqbFaNT66THEZ79ob1hKq2rywSkb1V3Xo1U+ZGeBc=";
  };

  vendorHash = "sha256-XEZ0sLvC7PwNarYa9xdKUOguJKEK50vWW0g2jnWJMu0=";
=======
    sha256 = "sha256-gBZY/xj/T7UYQ5mnN6udpBKViE/RYz9tmbmYN+JqsBk=";
  };

  vendorHash = "sha256-NR4YoaJ5ztc7eokRexNzDBtAH7JM4vZH13K550KWFNM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Tool for managing secrets on Google Cloud";
    homepage = "https://github.com/GoogleCloudPlatform/berglas";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Tool for managing secrets on Google Cloud";
    homepage = "https://github.com/GoogleCloudPlatform/berglas";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "berglas";
  };
}
