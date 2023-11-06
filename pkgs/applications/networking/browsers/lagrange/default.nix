{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, nix-update-script
, cmake
, pkg-config
, fribidi
, harfbuzz
, libwebp
, mpg123
, SDL2
, the-foundation
, AppKit
, zip
, enableTUI ? false, ncurses, sealcurses
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lagrange";
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "lagrange";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x80le9/mkL57NQGgmqAdbixYGxcoKKO3Rl+BlpOzTwc=";
  };

  patches = [
    # Remove on next release
    (fetchpatch {
      url = "https://github.com/skyjake/lagrange/commit/e8295f0065e8ecddab2e291e420098ac7981e0a9.patch";
      hash = "sha256-s8Ryace6DOjw4C4h1Kb2ti5oygvsAAs/MF9pC3eQbAM=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config zip ];

  buildInputs = [ the-foundation ]
    ++ lib.optionals (!enableTUI) [ fribidi harfbuzz libwebp mpg123 SDL2 ]
    ++ lib.optionals enableTUI [ ncurses sealcurses ]
    ++ lib.optional stdenv.isDarwin AppKit;

  cmakeFlags = lib.optionals enableTUI [
    "-DENABLE_TUI=YES"
    "-DENABLE_MPG123=NO"
    "-DENABLE_WEBP=NO"
    "-DENABLE_FRIBIDI=NO"
    "-DENABLE_HARFBUZZ=NO"
    "-DENABLE_POPUP_MENUS=NO"
    "-DENABLE_IDLE_SLEEP=NO"
    "-DCMAKE_INSTALL_DATADIR=${placeholder "out"}/share"
  ];

  installPhase = lib.optionalString (stdenv.isDarwin && !enableTUI) ''
    mkdir -p $out/Applications
    mv Lagrange.app $out/Applications
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A Beautiful Gemini Client";
    homepage = "https://gmi.skyjake.fi/lagrange/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
