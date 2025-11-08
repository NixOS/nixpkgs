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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "ripose-jp";
    repo = "Memento";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IvzvlToSyA20FWU0x+wgE3rT0dYbuY6xyaGgz1D1f6Q=";
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

  meta = with lib; {
    description = "Mpv-based video player for studying Japanese";
    homepage = "https://ripose-jp.github.io/Memento/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ teto ];
    platforms = platforms.linux;
    mainProgram = "memento";
  };
})
