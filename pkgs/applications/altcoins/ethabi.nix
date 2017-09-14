{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "ethabi-${version}";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "ethabi";
    rev = "18ddc983d77b2a97e6c322abcc23bec59940d65f";
    sha256 = "1rg7ydvnhlg8w6blilm3cv6v4q51x1hgrbkln2ikhpdq0vakp5fd";
  };

  depsSha256 = "1n4rxipna307r4xppb2iaads7kpa3yjv99fimvpn8l0f999ir2rz";

  cargoBuildFlags = ["--features cli"];

  meta = {
    description = "Ethereum function call encoding (ABI) utility";
    homepage = https://github.com/ethcore/ethabi/;
    maintainers = [stdenv.lib.maintainers.dbrock];
    inherit version;
  };
}
