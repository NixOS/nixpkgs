{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "zktree";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "alirezameskin";
    repo = "zktree";
    rev = version;
    sha256 = "11w86k1w5zryiq6bqr98pjhffd3l76377yz53qx0n76vc5374fk9";
  };

  cargoSha256 = "1d35jrxvhf7m04s1kh0yrfhy9j9i6qzwbw2mwapgsrcsr5vhxasn";

  meta = with lib; {
    description = "A small tool to display Znodes in Zookeeper in tree structure.";
    homepage = "https://github.com/alirezameskin/zktree";
    license = licenses.unlicense;
    maintainers = with lib.maintainers; [ alirezameskin ];
  };
}
