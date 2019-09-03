{ version
, sha256
, cargoSha256
}:

{ lib
, fetchFromGitHub
, rustPlatform

, cmake
, openssl
, pkgconfig
, systemd
}:

rustPlatform.buildRustPackage rec {
  pname = "parity";
  inherit version;
  inherit cargoSha256;

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "parity-ethereum";
    rev = "v${version}";
    inherit sha256;
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ openssl systemd ];

  cargoBuildFlags = [ "--features final" ];

  # test result: FAILED. 80 passed; 12 failed; 0 ignored; 0 measured; 0 filtered out
  doCheck = false;

  meta = with lib; {
    description = "Fast, light, robust Ethereum implementation";
    homepage = "http://parity.io";
    license = licenses.gpl3;
    maintainers = with maintainers; [ akru xrelkd ];
    platforms = platforms.linux;
  };
}
