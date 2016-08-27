{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "ethabi-${version}";
  version = "0.2.0-unstable-2016-08-17";

  src = fetchFromGitHub {
    owner = "ethcore";
    repo = "ethabi";
    rev = "2b6e8e4173ed9fdfd4c8028fccc8130b9eb5491d";
    sha256 = "1nhgggs4m41bsws9q2174jlv0q4f5nwm0ia24sh8rmagpvp3dsqi";
  };

  depsSha256 = "16r2p0zsypr3q814jalpmmlw4fh6d8ychjm74z5dfb1yvs1y2xzc";

  meta = {
    description = "Ethereum function call encoding (ABI) utility";
    homepage = https://github.com/ethcore/ethabi/;
    inherit version;
  };
}
