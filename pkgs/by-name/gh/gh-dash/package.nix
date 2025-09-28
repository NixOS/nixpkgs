{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  gh-dash,
}:

buildGoModule rec {
  pname = "gh-dash";
  version = "4.16.2";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${version}";
    hash = "sha256-LMKY7UpJtCrlMaui+fllc6mwVYQyVkuIM8bb6fop1Bc=";
  };

  vendorHash = "sha256-AeDGtEh+8sAczm0hBebvMdK/vTDzQsSXcB0xIYcQd8o=";

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
    homepage = "https://www.gh-dash.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
    mainProgram = "gh-dash";
  };
}
