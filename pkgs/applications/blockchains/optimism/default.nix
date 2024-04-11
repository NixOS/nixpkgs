{ lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "optimism";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-p3dbyszUeknAXrI1WqN9WS6AkEYQdVfMP90Kk/L41vM=";
    fetchSubmodules = true;
  };

  subPackages = [ "op-node/cmd" "op-proposer/cmd" "op-batcher/cmd" ];

  vendorHash = "sha256-24zj480UU9SYqr2mV6rCJ46gwLgzilLuhqrkNKHVR28=";

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
