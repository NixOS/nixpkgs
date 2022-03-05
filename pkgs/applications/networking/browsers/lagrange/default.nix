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
, zip
, zlib
}:

stdenv.mkDerivation rec {
  pname = "lagrange";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "lagrange";
    rev = "v${version}";
    sha256 = "sha256-RrdD+G8DKOBm0TpmRQg1uMGNFAlAADFeK3h6oyo5RZ4=";
    fetchSubmodules = true;
  };

  postPatch = ''
    rm -r lib/fribidi lib/harfbuzz
  '';

  nativeBuildInputs = [ cmake pkg-config zip ];

  buildInputs = [ fribidi harfbuzz libunistring libwebp mpg123 openssl pcre SDL2 zlib ]
    ++ lib.optional stdenv.isDarwin AppKit;

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
