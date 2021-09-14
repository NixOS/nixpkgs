{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, cmake
, pkg-config
, fribidi
, harfbuzz
, libunistring
, mpg123
, openssl
, pcre
, SDL2
, AppKit
, zlib
}:

stdenv.mkDerivation rec {
  pname = "lagrange";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "lagrange";
    rev = "v${version}";
    sha256 = "sha256-ZrpgSst17jjly6UnEWmlIBYjjW9nGFs7GTbVaKpZMrM=";
    fetchSubmodules = true;
  };

  postPatch = ''
    rm -r lib/fribidi lib/harfbuzz
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ fribidi harfbuzz libunistring mpg123 openssl pcre SDL2 zlib ]
    ++ lib.optional stdenv.isDarwin AppKit;

  hardeningDisable = lib.optional (!stdenv.cc.isClang) "format";

  cmakeFlags = [
    "-DENABLE_HARFBUZZ_MINIMAL:BOOL=OFF"
    "-DENABLE_FRIBIDI_BUILD:BOOL=OFF"
  ];

  installPhase = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv Lagrange.app $out/Applications
  '';

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
