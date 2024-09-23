{ lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "optimism";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-PlwpN8P1t0NNIU+Ys50dIXmfUQFIY9e1tLABiVK0JQo=";
    fetchSubmodules = true;
  };

  subPackages = [ "op-node/cmd" "op-proposer/cmd" "op-batcher/cmd" ];

  vendorHash = "sha256-n1uJ/dkEjjsTdmL7TeHU4PKnBhiRrqCNtcGxK70Q0c4=";

  buildInputs = [
    libpcap
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Optimism is Ethereum, scaled";
    homepage = "https://github.com/ethereum-optimism/optimism";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "cmd";
  };
}
