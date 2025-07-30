{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  scmpuff,
}:

buildGoModule rec {
  pname = "scmpuff";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mroth";
    repo = "scmpuff";
    rev = "v${version}";
    sha256 = "sha256-c8F7BgjbR/w2JH8lE2t93s8gj6cWbTQGIkgYTQp9R3U=";
  };

  vendorHash = "sha256-7xSMToc5rlxogS0N9H6siauu8i33zUA5/omqXAszDOg=";

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = scmpuff;
    command = "scmpuff version";
  };

  meta = with lib; {
    description = "Add numbered shortcuts to common git commands";
    homepage = "https://github.com/mroth/scmpuff";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
    mainProgram = "scmpuff";
  };
}
