{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, cmake
, pkg-config
, fribidi
, harfbuzz
, libunistring
, libwebp
, mpg123
, openssl
, pcre
, SDL2
, AppKit
, zlib
}:

stdenv.mkDerivation rec {
  pname = "lagrange";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "lagrange";
    rev = "v${version}";
    sha256 = "sha256-iJ6+tc5nls8E/9/Jp5OS9gfJo8SJ5bN+Im/JzEYEAfI=";
    fetchSubmodules = true;
  };

  postPatch = ''
    rm -r lib/fribidi lib/harfbuzz
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ fribidi harfbuzz libunistring libwebp mpg123 openssl pcre SDL2 zlib ]
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
