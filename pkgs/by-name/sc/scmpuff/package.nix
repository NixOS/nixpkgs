{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  scmpuff,
}:

buildGoModule rec {
  pname = "scmpuff";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mroth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+L0W+M8sZdUSCWj9Ftft1gkRRfWMHdxon2xNnotx8Xs=";
  };

  vendorHash = "sha256-7WHVSEz3y1nxWfbxkzkfHhINLC8+snmWknHyUUpNy7c=";

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
