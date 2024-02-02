{ lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "optimism";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-fg63J1qgsQOTCLHgEWSI6ZxNf9XIPq+aYCumJ/FEx/s=";
    fetchSubmodules = true;
  };

  subPackages = [ "op-node/cmd" "op-proposer/cmd" "op-batcher/cmd" ];

  vendorHash = "sha256-9mLS44wzPslPfa+QwBg05+QSL6F0c8fcev1VOI9VPE4=";

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
