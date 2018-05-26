{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "ethabi-${version}";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "ethabi";
    rev = "v${version}";
    sha256 = "0kxflixmgycdh7sv73zf2mrkbcfzzw7f5sjbsjks9crc9cvjqi6p";
  };

  cargoSha256 = "18rigpsmfiv6im2sspnxadgqrlfdp9dd75ji8s56ksc9g7hrc3wz";

  cargoBuildFlags = ["--features cli"];

  meta = {
    description = "Ethereum function call encoding (ABI) utility";
    homepage = https://github.com/ethcore/ethabi/;
    maintainers = [stdenv.lib.maintainers.dbrock];
    inherit version;
  };
}
