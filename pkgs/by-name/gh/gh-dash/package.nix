{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  gh-dash,
}:

buildGoModule rec {
  pname = "gh-dash";
  version = "4.18.0";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${version}";
    hash = "sha256-iYz4rHoIWIW1XR83ZqkAbsU+5mIkLzq8wemVKUMGf6A=";
  };

  vendorHash = "sha256-IsEz6hA8jnWP+2ELkZ6V5Y0/rpTz1tAzaYJvzgPQQCo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dlvhdr/gh-dash/v4/cmd.Version=${version}"
  ];

  checkFlags = [
    # requires network
    "-skip=TestFullOutput"
  ];

  passthru.tests = {
    version = testers.testVersion { package = gh-dash; };
  };

  meta = {
    changelog = "https://github.com/dlvhdr/gh-dash/releases/tag/${src.rev}";
    description = "Github Cli extension to display a dashboard with pull requests and issues";
    homepage = "https://www.gh-dash.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
    mainProgram = "gh-dash";
  };
}
