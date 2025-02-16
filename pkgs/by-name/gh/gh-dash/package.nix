{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  gh-dash,
}:

buildGoModule rec {
  pname = "gh-dash";
  version = "4.11.0";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${version}";
    hash = "sha256-i7PsOd2avaKY0FvsjBpTQk6rijf9EE6kVRicfe4k8NE=";
  };

  vendorHash = "sha256-lqmz+6Cr9U5IBoJ5OeSN6HKY/nKSAmszfvifzbxG7NE=";

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
