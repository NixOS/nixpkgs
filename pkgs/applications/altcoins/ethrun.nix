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

  depsSha256 = "14x8pbjgkz0g724lnvd9mi2alqd6fipjljw6xsraf9gqwijn1knq";

  meta = {
    description = "Directly run Ethereum bytecode";
    homepage = https://github.com/dapphub/ethrun/;
    maintainers = [stdenv.lib.maintainers.dbrock];
    inherit version;
  };
}
