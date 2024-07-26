{ lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "optimism";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-ru6/PDgsQOpOjKSolk3US6dV/NMH/lWEuJf5lmuR4SI=";
    fetchSubmodules = true;
  };

  subPackages = [ "op-node/cmd" "op-proposer/cmd" "op-batcher/cmd" ];

  vendorHash = "sha256-BrlF8uwnD1hlrrpvc2JEsaPY4/+bGR1cXwjkkYANyiE=";

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
