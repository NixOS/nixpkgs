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
  version = "1.15.6";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "lagrange";
    rev = "v${finalAttrs.version}";
    hash = "sha256-V9zrwSAflatGcN5cOOzHyyW73FN3rU+l5xUlPwy8Huk=";
  };

  patches = [
    # https://github.com/skyjake/lagrange/issues/589
    (fetchpatch {
      url = "https://github.com/skyjake/lagrange/commit/e8a4dad6930d16aa0811d04d06432cd6b59b472e.patch";
      hash = "sha256-60YPmZPalnoo9AjwqKpswHkKAM/hKSIOapgPwSi4Qzk=";
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
