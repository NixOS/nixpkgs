{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  wrapQtAppsHook,

  # before that => zeal
  sqlite,
  json_c,
  mecab,
  libzip,
  mpv,
  yt-dlp,
  # optional
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "memento";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "ripose-jp";
    repo = "Memento";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8kgMEHDLb2EtwmIOs6WQO3a1QSypwN1FX/f2n7uRBFs=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    sqlite
    json_c
    libzip
    mecab
  ];

  propagatedBuildInputs = [ mpv ];

  preFixup = ''
    wrapProgram "$out/bin/memento" \
      --prefix PATH : "${yt-dlp}/bin" \
  '';

  meta = {
    description = "Mpv-based video player for studying Japanese";
    homepage = "https://ripose-jp.github.io/Memento/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ teto ];
    platforms = lib.platforms.linux;
    mainProgram = "memento";
  };
})
