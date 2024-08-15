{ lib
, fetchFromGitHub
, buildGoModule
, testers
, gh-dash
}:

buildGoModule rec {
  pname = "gh-dash";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${version}";
    hash = "sha256-lOJN4wSxE3VX/Pb8Aa+ex6hkiPieFelmtn84+SmzOxE=";
  };

  vendorHash = "sha256-JOd2czYWVgE1jBfeuoVRp+oE/asyk50o5Pf021jD5mY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dlvhdr/gh-dash/v4/cmd.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion { package = gh-dash; };
  };

  meta = {
    changelog = "https://github.com/dlvhdr/gh-dash/releases/tag/${src.rev}";
    description = "Github Cli extension to display a dashboard with pull requests and issues";
    homepage = "https://github.com/dlvhdr/gh-dash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
    mainProgram = "gh-dash";
  };
}
