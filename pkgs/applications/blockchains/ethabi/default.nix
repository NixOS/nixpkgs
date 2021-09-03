{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "ethabi";
  version = "13.0.0";

  src = fetchFromGitHub {
    owner = "rust-ethereum";
    repo = "ethabi";
    rev = "v${version}";
    sha256 = "sha256-bl46CSVP1MMYI3tkVAHFrjMFwTt8QoleZCV9pMIMZyc=";
  };

  cargoSha256 = "sha256-Jz0uEP2/ZjLS+GbCp7lNyJQdFDjTSFthjBdC/Z4tkTs=";

  cargoPatches = [ ./add-Cargo-lock.patch ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Ethereum function call encoding (ABI) utility";
    homepage = "https://github.com/rust-ethereum/ethabi";
    maintainers = [ maintainers.dbrock ];
    license = licenses.asl20;
  };
}
