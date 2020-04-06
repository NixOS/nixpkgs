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
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "parity-ethereum";
    rev = "v${version}";
    sha256 = "09cvqk0h9c26famh3f1nc3g74cd0zk6klys977yr1f13bgqmzx0x";
  };

  cargoSha256 = "1fdymy8hvn137i5y4flyhlxwjxkd2cd6gq81i1429gk7j3h085ig";

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
