{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ethabi";
  version = "11.0.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "ethabi";
    rev = "v${version}";
    sha256 = "1gqd3vwsvv1wvi659qcdywgmh41swblpwmmxb033k8irw581dwq4";
  };

  cargoSha256 = "19qlc7sp7k1d0ybd777jv9dbn1ivv02q76i9hffqvangqwnblcyw";

  meta = with lib; {
    description = "Ethereum function call encoding (ABI) utility";
    homepage = "https://github.com/ethcore/ethabi/";
    maintainers = [ maintainers.dbrock ];
    license = licenses.gpl3;
    inherit version;
  };
}
