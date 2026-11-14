{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  apple-sdk_15,
  freetype,
  fribidi,
  harfbuzz,
  libjxl,
  libogg,
  libwebp,
  libx11,
  mpg123,
  opusfile,
  sdl3,
  the-foundation,
  zip,
  enableTUI ? false,
  ncurses,
  sealcurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lagrange";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "lagrange";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Or4roE4c7PUW9CmItoBSMldW6iM9lR38vsM+nRPPOrY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    zip
  ];

  buildInputs = [
    the-foundation
    freetype
    fribidi
    harfbuzz
    libjxl
    libogg
    libwebp
    libx11
    mpg123
    opusfile
    sdl3
  ]
  ++ lib.optionals enableTUI [
    ncurses
    sealcurses
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TUI" enableTUI)
    (lib.cmakeFeature "CMAKE_INSTALL_DATAROOTDIR" "${placeholder "out"}/share")
  ];

  installPhase =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      mv app/Lagrange.app $out/Applications
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin && enableTUI) ''
      # https://github.com/skyjake/lagrange/issues/610
      make install
      install -d $out/share/lagrange
      ln -s $out/Applications/Lagrange.app/Contents/Resources/resources.lgr $out/share/lagrange/resources.lgr
    '';

  passthru = {
    updateScript = nix-update-script { attrPath = "lagrange"; };
  };

  meta = {
    description = "Beautiful Gemini Client";
    homepage = "https://gmi.skyjake.fi/lagrange/";
    mainProgram = "lagrange";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
