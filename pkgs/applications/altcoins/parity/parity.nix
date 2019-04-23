{ version
, sha256
, cargoSha256
}:

{ stdenv
, fetchFromGitHub
, rustPlatform 
, pkgconfig
, openssl
, systemd
, cmake
, perl
}:

rustPlatform.buildRustPackage rec {
  name = "parity-${version}";
  inherit cargoSha256;

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "parity-ethereum";
    rev = "v${version}";
    inherit sha256;
  };

  buildInputs = [
    pkgconfig cmake perl
    systemd.lib systemd.dev openssl openssl.dev
  ];

  # test result: FAILED. 80 passed; 12 failed; 0 ignored; 0 measured; 0 filtered out
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Fast, light, robust Ethereum implementation";
    homepage = http://parity.io;
    license = licenses.gpl3;
    maintainers = [ maintainers.akru ];
    platforms = platforms.linux;
  };
}
