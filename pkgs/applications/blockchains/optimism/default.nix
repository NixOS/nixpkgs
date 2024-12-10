{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule rec {
  pname = "optimism";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-220fnMJDgvdGJtN0XkKtqNP94KfbmN5qhghfjHJaAxQ=";
    fetchSubmodules = true;
  };

  subPackages = [
    "op-node/cmd"
    "op-proposer/cmd"
    "op-batcher/cmd"
  ];

  vendorHash = "sha256-yG910xpk2MHCD2LHh7aD09KMCux1X252fOHCsyUc/ks=";

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
