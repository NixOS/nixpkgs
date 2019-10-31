{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  pname = "ethabi";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "ethabi";
    rev = "v${version}";
    sha256 = "1gqd3vwsvv1wvi659qcdywgmh41swblpwmmxb033k8irw581dwq4";
  };

  cargoSha256 = "0zkdai31jf8f5syklaxq43ydjvp5xclr8pd6y1q6vkwjz6z49hzm";

  cargoBuildFlags = ["--features cli"];

  meta = with stdenv.lib; {
    description = "Ethereum function call encoding (ABI) utility";
    homepage = https://github.com/ethcore/ethabi/;
    maintainers = [ maintainers.dbrock ];
    license = licenses.gpl3;
    inherit version;
  };
}
