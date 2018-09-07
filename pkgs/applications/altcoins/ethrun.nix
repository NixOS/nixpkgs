{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "ethrun-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "dapphub";
    repo = "ethrun";
    rev = "v${version}";
    sha256 = "1w651g4p2mc4ljp20l8lwvfx3l3fzyp6gf2izr85vyb1wjbaccqn";
  };

  cargoSha256 = "14x8pbjgkz0g724lnvd9mi2alqd6fipjljw6xsraf9gqwijn1kn0";

  meta = with stdenv.lib; {
    description = "Directly run Ethereum bytecode";
    homepage = https://github.com/dapphub/ethrun/;
    maintainers = [ maintainers.dbrock ];
    license = licenses.gpl3;
    broken = true; # mark temporary as broken
    inherit version;
  };
}
