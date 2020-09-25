{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "turbo-geth";
  version = "2020.11.01";

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hm8kqd0w231mlclsmsghf15r8pbrs5g064mkpx59qpqzk37lgss";
  };

  vendorSha256 = "0b7ldrnwkz3r1d4fw95hvvpi3bz56d9v8p2mjzdvlpk5zhl2a37p";
  runVend = true;

  subPackages = [
    "cmd/tg"
    "cmd/restapi"
    "cmd/rpcdaemon"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/ledgerwatch/turbo-geth/";
    description = "Ethereum node and geth fork focused on scalability and modularity";
    license = with licenses; [ lgpl3 gpl3 ];
    maintainers = with maintainers; [ xwvvvvwx ];
  };
}
