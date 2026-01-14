{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cvemap";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cvemap";
    tag = "v${version}";
    hash = "sha256-pzCLzSsAaoiRrTBENnmyqaSyDnHQdDAcTNyaxpc7mt4=";
  };

  vendorHash = "sha256-4GW1mgwOXbdiDmQoN1yxVOJC8mXpqkKliabWZzvOff4=";

  subPackages = [
    "cmd/cvemap/"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to work with CVEs";
    homepage = "https://github.com/projectdiscovery/cvemap";
    changelog = "https://github.com/projectdiscovery/cvemap/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cvemap";
  };
}
