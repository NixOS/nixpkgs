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
  libX11,
  mpg123,
  opusfile,
  SDL2,
  the-foundation,
  zip,
  enableTUI ? false,
  ncurses,
  sealcurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lagrange";
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "lagrange";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OsyWedXer1xFnPCYRpFeBQfUjpFhGViqx2FTOeZV4PI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    zip
  ];

  buildInputs = [
    the-foundation
    fribidi
    harfbuzz
    libogg
    libwebp
    libX11
    mpg123
    opusfile
    SDL2
  ]
  ++ lib.optionals enableTUI [
    ncurses
    sealcurses
  ];

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
