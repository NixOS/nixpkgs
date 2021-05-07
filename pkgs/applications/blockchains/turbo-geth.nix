{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "turbo-geth";
  version = "2021.05.01";

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zvxtBK0/6fShxAZfU4gTV0XiP6TzhKFNsADSZA9gv0Y=";
  };

  vendorSha256 = "0c8p6djs0zcci8sh4zgzky89155mr4cfqlax025618x8vngrsxf2";
  runVend = true;

  subPackages = [
    "cmd/tg"
    "cmd/evm"
    "cmd/rpcdaemon"
    "cmd/rlpdump"
  ];

  meta = with lib; {
    homepage = "https://github.com/ledgerwatch/turbo-geth/";
    description = "Ethereum node and geth fork focused on scalability and modularity";
    license = with licenses; [ lgpl3Plus gpl3Plus ];
    maintainers = with maintainers; [ xwvvvvwx ];
  };
}
