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

  cargoSha256 = "0ad0kab3v50ic98dxfxmaai8z7kiah39w9b29q4d38q23zd8kz7k";

  meta = with lib; {
    description = "Ethereum function call encoding (ABI) utility";
    homepage = "https://github.com/ethcore/ethabi/";
    maintainers = [ maintainers.dbrock ];
    license = licenses.gpl3;
    inherit version;
  };
}
