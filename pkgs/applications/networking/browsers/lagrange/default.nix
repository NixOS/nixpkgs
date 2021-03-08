{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, libunistring
, openssl
, pcre
, SDL2
, AppKit
}:

stdenv.mkDerivation rec {
  pname = "lagrange";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "lagrange";
    rev = "v${version}";
    sha256 = "1l9qcymjwg3wzbbi4hcyzfrxyqgz2xdy4ab3lr0zq38v025d794n";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libunistring openssl pcre SDL2 ]
    ++ lib.optional stdenv.isDarwin AppKit;

  hardeningDisable = lib.optional (!stdenv.cc.isClang) "format";

  installPhase = if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    mv Lagrange.app $out/Applications
  '' else null;

  meta = with lib; {
    description = "A Beautiful Gemini Client";
    homepage = "https://gmi.skyjake.fi/lagrange/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
