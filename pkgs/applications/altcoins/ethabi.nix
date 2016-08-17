{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "ethabi-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ethcore";
    repo = "ethabi";
    rev = "fbed04984cab0db8767e01054ee16271b8e36281";
    sha256 = "1zgyyg1i5wmz8l1405yg5jmq4ddq530sl7018pkkc7l6cjj3bbhd";
  };

  depsSha256 = "0srxv0wbhvyflc967lkpd2mx5nk7asx2cbxa0qxvas16wy6vxz52";

  meta = {
    description = "Ethereum function call encoding (ABI) utility";
    homepage = https://github.com/ethcore/ethabi/;
    maintainers = [stdenv.lib.maintainers.dbrock];
    inherit version;
  };
}
