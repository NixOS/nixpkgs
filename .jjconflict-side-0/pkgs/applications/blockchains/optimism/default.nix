{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule rec {
  pname = "optimism";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-pAmstWA6up0CvHEQW5RnDYumdwKP0i6fpz59EYTBsmU=";
    fetchSubmodules = true;
  };

  subPackages = [
    "op-node/cmd"
    "op-proposer/cmd"
    "op-batcher/cmd"
  ];

  vendorHash = "sha256-Sr9OECXbRa4SPe3owMto2EbnAIygeIEmZv73hvA6iww=";

  buildInputs = [
    libpcap
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Optimism is Ethereum, scaled";
    homepage = "https://github.com/ethereum-optimism/optimism";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "cmd";
  };
}
