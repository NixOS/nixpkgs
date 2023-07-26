{ lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "optimism";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-COTpmjDH1u2dJA0nKPBG1Aocpyyo8NdtowwjHDTbEKI=";
    fetchSubmodules = true;
  };

  subPackages = [ "op-node/cmd" "op-proposer/cmd" "op-batcher/cmd" ];

  vendorHash = "sha256-yAUeCX05dCVEvIzp0cXB/qYVtu3gQfgFi1CNZZKllOU=";

  buildInputs = [
    libpcap
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Optimism is Ethereum, scaled";
    homepage = "https://github.com/ethereum-optimism/optimism";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
