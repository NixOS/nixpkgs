{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  faraday,
}:

buildGoModule rec {
  pname = "faraday";
  version = "0.2.11-alpha";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "faraday";
    rev = "v${version}";
    hash = "sha256-KiGj24sBeClmzW60lRrvXwgXf3My7jhHTY+VhIMMp0k=";
  };

  vendorHash = "sha256-ku/4VE1Gj62vuJLh9J6vKlxpyI7S0RsMDozV7U5YDe4=";

  subPackages = [
    "cmd/frcli"
    "cmd/faraday"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = faraday;
  };

  meta = with lib; {
    description = "LND Channel Management Tools";
    homepage = "https://github.com/lightninglabs/faraday";
    license = licenses.mit;
    maintainers = with maintainers; [
      proofofkeags
      prusnak
    ];
  };
}
