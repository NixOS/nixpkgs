{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ethabi";
  version = "11.0.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "ethabi";
    rev = "v${version}";
    sha256 = "1gqd3vwsvv1wvi659qcdywgmh41swblpwmmxb033k8irw581dwq4";
  };

  cargoSha256 = "1hx8qw51rl7sn9jmnclw0hc4rx619hf78hpaih5mvny3k0zgiwpm";

  meta = with stdenv.lib; {
    description = "Ethereum function call encoding (ABI) utility";
    homepage = "https://github.com/ethcore/ethabi/";
    maintainers = [ maintainers.dbrock ];
    license = licenses.gpl3;
    inherit version;
  };
}
