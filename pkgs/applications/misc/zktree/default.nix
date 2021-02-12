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

  cargoSha256 = "0ig1mw21dx0dxhzfsgmsi2l95nb6rl1ycmildl24r4bmi291mlv5";

  meta = with lib; {
    description = "A small tool to display Znodes in Zookeeper in tree structure.";
    homepage = "https://github.com/alirezameskin/zktree";
    license = licenses.unlicense;
    maintainers = with lib.maintainers; [ alirezameskin ];
  };
}
