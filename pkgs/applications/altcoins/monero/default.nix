{ stdenv, fetchpatch, fetchFromGitHub, cmake
, boost, miniupnpc, openssl, pkgconfig, unbound
, IOKit
}:

stdenv.mkDerivation rec {
  name    = "monero-${version}";
  version = "0.11.1.0";

  src = fetchFromGitHub {
    owner  = "monero-project";
    repo   = "monero";
    rev    = "v${version}";
    sha256 = "0nrpxx6r63ia6ard85d504x2kgaikvrhb5sg93ml70l6djyy1148";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ boost miniupnpc openssl unbound ]
    ++ stdenv.lib.optional stdenv.isDarwin IOKit;

  patches = [
    ./build-wallet-rpc.patch # fixed in next release
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_GUI_DEPS=ON"
  ];

  doCheck = false;

  installPhase = ''
    make install
    install -Dt "$out/bin/" \
      bin/monero-blockchain-export \
      bin/monero-blockchain-import \
      bin/monero-wallet-rpc
  '';

  meta = with stdenv.lib; {
    description = "Private, secure, untraceable currency";
    homepage    = https://getmonero.org/;
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = [ maintainers.ehmry ];
  };
}
