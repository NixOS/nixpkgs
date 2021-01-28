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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "lagrange";
    rev = "v${version}";
    sha256 = "04bp5k1byjbzwnmcx4b7sw68pr2jrj4c21z76jq311hyrmanj6fi";
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
