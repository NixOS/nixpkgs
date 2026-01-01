{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  kool,
}:

buildGoModule rec {
  pname = "kool";
<<<<<<< HEAD
  version = "3.5.3";
=======
  version = "3.5.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kool-dev";
    repo = "kool";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-pZ667bDyRWIrImBNHyhkOGl/22gjHKX6KsVSTckS1U4=";
=======
    hash = "sha256-yUJbuMOLEa9LVRltskSwD0XBdmwwLcEaLYUHsSQOiCk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-IqUkIf0uk4iUTedTO5xRzjmJwHS+p6apo4E0WEEU6cc=";

  ldflags = [
    "-s"
    "-w"
    "-X=kool-dev/kool/commands.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = kool;
    };
  };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "From local development to the cloud: development workflow made easy";
    mainProgram = "kool";
    homepage = "https://kool.dev";
    changelog = "https://github.com/kool-dev/kool/releases/tag/${src.rev}";
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
