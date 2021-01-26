{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "turbo-geth";
  version = "2021.01.01";

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a570570cmyngbz645728jdd0d2xmnyrnln2gbxnngiv4v62dxls";
  };

  vendorSha256 = "1x3mhfc16slaamp51rbscfwll25qj6ama1xkysidy7rscmmsj392";
  runVend = true;

  subPackages = [
    "cmd/tg"
    "cmd/restapi"
    "cmd/rpcdaemon"
  ];

  meta = with lib; {
    homepage = "https://github.com/ledgerwatch/turbo-geth/";
    description = "Ethereum node and geth fork focused on scalability and modularity";
    license = with licenses; [ lgpl3 gpl3 ];
    maintainers = with maintainers; [ xwvvvvwx ];
  };
}
