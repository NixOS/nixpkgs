{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudlist";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cloudlist";
    rev = "refs/tags/v${version}";
    hash = "sha256-HV4qhQgeLKwkyrRFzRQibqjWRyjLBtoWVdliJ+iyyBc=";
  };

  vendorHash = "sha256-6J9AWONLP/FvR0dXt5Zx4n+kTpmnxF79HcWVFp9OZ0g=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Tool for listing assets from multiple cloud providers";
    mainProgram = "cloudlist";
    homepage = "https://github.com/projectdiscovery/cloudlist";
    changelog = "https://github.com/projectdiscovery/cloudlist/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
