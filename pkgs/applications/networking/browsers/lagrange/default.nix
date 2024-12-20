{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  fribidi,
  harfbuzz,
  libogg,
  libwebp,
  mpg123,
  opusfile,
  SDL2,
  the-foundation,
  AppKit,
  zip,
  enableTUI ? false,
  ncurses,
  sealcurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lagrange";
  version = "1.18.4";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "lagrange";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Bty2TRL5blduhucYmI6x3RZVdgrY0/7Dtm5kgQ2N3ec=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    zip
  ];

  buildInputs =
    [
      the-foundation
      fribidi
      harfbuzz
      libogg
      libwebp
      mpg123
      opusfile
      SDL2
    ]
    ++ lib.optionals enableTUI [
      ncurses
      sealcurses
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin AppKit;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TUI" enableTUI)
    (lib.cmakeFeature "CMAKE_INSTALL_DATAROOTDIR" "${placeholder "out"}/share")
  ];

  installPhase =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      mv Lagrange.app $out/Applications
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin && enableTUI) ''
      # https://github.com/skyjake/lagrange/issues/610
      make install
      install -d $out/share/lagrange
      ln -s $out/Applications/Lagrange.app/Contents/Resources/resources.lgr $out/share/lagrange/resources.lgr
    '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Beautiful Gemini Client";
    homepage = "https://gmi.skyjake.fi/lagrange/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
