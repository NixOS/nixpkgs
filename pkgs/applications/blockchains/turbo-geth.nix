{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "turbo-geth";
  version = "2021.02.01";

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9z0Hogu/VgGxvgQMKIImv+qyTqTmR40JS4NNIOk5EZI=";
  };

  vendorSha256 = "sha256-Ho68+SzYELQN4DE57LNSXeHIu43zAOb7HK/jx7PFdXk=";
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
