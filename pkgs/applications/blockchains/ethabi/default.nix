{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "ethabi";
  version = "13.0.0";

  src = fetchFromGitHub {
    owner = "rust-ethereum";
    repo = "ethabi";
    rev = "v${version}";
    sha256 = "sha256-bl46CSVP1MMYI3tkVAHFrjMFwTt8QoleZCV9pMIMZyc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "Ethereum function call encoding (ABI) utility";
    homepage = "https://github.com/rust-ethereum/ethabi";
    maintainers = [ maintainers.dbrock ];
    license = licenses.asl20;
  };
}
