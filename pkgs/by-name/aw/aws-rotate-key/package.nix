{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  aws-rotate-key,
}:

buildGoModule rec {
  pname = "aws-rotate-key";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Fullscreen";
    repo = "aws-rotate-key";
    rev = "v${version}";
    sha256 = "sha256-fYpgHHOw0k/8WLGhq+uVOvoF4Wff6wzTXuN8r4D+TmU=";
  };

  vendorHash = "sha256-gXtTd7lU9m9rO1w7Fx8o/s45j63h6GtUZrjOzFI4Q/o=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = aws-rotate-key;
    command = "AWS_SHARED_CREDENTIALS_FILE=/dev/null aws-rotate-key --version";
  };

  meta = with lib; {
    description = "Easily rotate your AWS key";
    homepage = "https://github.com/Fullscreen/aws-rotate-key";
    license = licenses.mit;
    maintainers = [ maintainers.mbode ];
    mainProgram = "aws-rotate-key";
  };
}
