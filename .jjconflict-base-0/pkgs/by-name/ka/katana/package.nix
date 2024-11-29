{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "katana";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "katana";
    rev = "refs/tags/v${version}";
    hash = "sha256-iE2dqm5ZNAULpEou/OuZ9yKS8xAzBZTkqwnwaoiREpo=";
  };

  vendorHash = "sha256-scg8EFKP98vGQPwc3ytGZPYu8D4Re7b/BlvlBCJuSPQ=";

  subPackages = [
    "cmd/katana"
  ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Next-generation crawling and spidering framework";
    mainProgram = "katana";
    homepage = "https://github.com/projectdiscovery/katana";
    changelog = "https://github.com/projectdiscovery/katana/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
