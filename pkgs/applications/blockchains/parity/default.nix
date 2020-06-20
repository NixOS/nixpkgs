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
  pname = "parity";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "parity-ethereum";
    rev = "v${version}";
    sha256 = "124km8c2d7877yzd885wzlcl3gky15isx0z2l1qg1q3cqdsb5mjf";
  };

  cargoSha256 = "0m4pms7agfyqk6gz6fwxdl8jmcyhphhzh3x4vykbi6186y7a8ihq";

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
    homepage = "http://parity.io";
    license = licenses.gpl3;
    maintainers = with maintainers; [ akru xrelkd ];
    platforms = platforms.linux;
  };
}
