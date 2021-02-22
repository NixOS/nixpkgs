{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, cmake
, pkg-config
, libunistring
, mpg123
, openssl
, pcre
, SDL2
, AppKit
}:

stdenv.mkDerivation rec {
  pname = "lagrange";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "lagrange";
    rev = "v${version}";
    sha256 = "0c7w4a19cwx3bkmbhc9c1wx0zmqd3a1grrj4ffifdic95wdihv7x";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libunistring mpg123 openssl pcre SDL2 ]
    ++ lib.optional stdenv.isDarwin AppKit;

  hardeningDisable = lib.optional (!stdenv.cc.isClang) "format";

  installPhase = if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    mv Lagrange.app $out/Applications
  '' else null;

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "A Beautiful Gemini Client";
    homepage = "https://gmi.skyjake.fi/lagrange/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
