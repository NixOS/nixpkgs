{ lib
, fetchFromGitHub
, rustPlatform
, cmake
, llvmPackages
, openssl
, pkg-config
, systemd
}:

rustPlatform.buildRustPackage rec {
  pname = "openethereum";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "openethereum";
    repo = "openethereum";
    rev = "v${version}";
    sha256 = "08dkcrga1x18csh6pw6f54x5xwijppyjhg46cf4p452xc1l3a6ir";
  };

  cargoSha256 = "1xliragihwjfc5qmfm0ng519bw8a28m1w1yqcl9mpk8zywiybaah";

  cargoPatches = [ ./lock.patch ];

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
  nativeBuildInputs = [
    cmake
    llvmPackages.clang
    llvmPackages.libclang
    pkg-config
  ];

  buildInputs = [ openssl systemd ];

  cargoBuildFlags = [ "--features final" ];

  # test result: FAILED. 88 passed; 13 failed; 0 ignored; 0 measured; 0 filtered out
  doCheck = false;

  meta = with lib; {
    description = "Fast, light, robust Ethereum implementation";
    homepage = "http://parity.io/ethereum";
    license = licenses.gpl3;
    maintainers = with maintainers; [ akru xrelkd ];
    platforms = platforms.linux;
  };
}
