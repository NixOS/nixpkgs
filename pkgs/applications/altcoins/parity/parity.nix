{ version
, sha256
, cargoSha256
, patches
}:

{ stdenv
, fetchFromGitHub
, rustPlatform 
, pkgconfig
, openssl
, systemd
}:

rustPlatform.buildRustPackage rec {
  name = "parity-${version}";
  inherit cargoSha256 patches;

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "parity";
    rev = "v${version}";
    inherit sha256;
  };

  buildInputs = [ pkgconfig systemd.lib systemd.dev openssl openssl.dev ]; 

  # Some checks failed
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Fast, light, robust Ethereum implementation";
    homepage = http://parity.io;
    license = licenses.gpl3;
    maintainers = [ maintainers.akru ];
    platforms = platforms.linux;
  };
}
