{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  gh-dash,
}:

buildGoModule rec {
  pname = "gh-dash";
  version = "4.16.0";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${version}";
    hash = "sha256-qqQ+UmeHvqA57evAn9dBLBeXx1n2z804XcmP82ZgEKc=";
  };

  vendorHash = "sha256-9nSuXZyi/+gyU2D1OL+6Bw9GKvYPdsj7dUmBcESHePw=";

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
