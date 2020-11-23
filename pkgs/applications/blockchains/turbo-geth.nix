{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "turbo-geth";
  version = "2020.11.02";

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bfywbg6mm3q4wd0mslcv5sj779277izzlqawqvqy3yxnpb6cwj5";
  };

  vendorSha256 = "16vawkky612zf45d8dhipjmhrprmi28z9wdcnjy07x3bxdyfbhfr";
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
