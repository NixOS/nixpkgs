{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "misconfig-mapper";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    rev = "refs/tags/v${version}";
    hash = "sha256-kudzShQdTHjv8ahdNavQHBSV0+xM7wygJNZbOz/stQI=";
  };

  vendorHash = "sha256-T4SDL1Pq3mfN6Qd13Safof1EgCqQVB2+K1qJHm+2ilc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to uncover security misconfigurations on popular third-party services";
    homepage = "https://github.com/intigriti/misconfig-mapper";
    changelog = "https://github.com/intigriti/misconfig-mapper/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "misconfig-mapper";
  };
}
