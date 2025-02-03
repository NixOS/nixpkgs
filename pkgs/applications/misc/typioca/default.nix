{ lib
, buildGoModule
, fetchFromGitHub
, testers
, typioca
}:

buildGoModule rec {
  pname = "typioca";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "bloznelis";
    repo = "typioca";
    rev = version;
    hash = "sha256-pYHEi1J8i8AeRM62TNrklivcmiv4Kq0a5Z7Fn1RB/Jk=";
  };

  vendorHash = "sha256-4T5xbCvzYn1bOKz0WCCiFojoQztOQ66SH4+WDI3Sn5g=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/bloznelis/typioca/cmd.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = typioca;
    };
  };

  meta = with lib; {
    description = "Cozy typing speed tester in terminal";
    homepage = "https://github.com/bloznelis/typioca";
    changelog = "https://github.com/bloznelis/typioca/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "typioca";
  };
}
