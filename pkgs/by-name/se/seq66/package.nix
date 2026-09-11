{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  which,
  alsa-lib,
  libjack2,
  liblo,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "seq66";
  version = "0.99.22";

  src = fetchFromGitHub {
    owner = "ahlstromcj";
    repo = "seq66";
    tag = finalAttrs.version;
    hash = "sha256-KtbMRRxKh+BuYujzh8kqKAbSN8xWUz/ktkCHBnTRaPw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    qt5.qttools
    which
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    libjack2
    liblo
    qt5.qtbase
  ];

  postPatch = ''
    for d in libseq66/src libsessions/include libsessions/src seq_qt5/src seq_rtmidi/src; do
      substituteInPlace "$d/Makefile.am" --replace-fail '$(git_info)' '${finalAttrs.version}'
    done
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/ahlstromcj/seq66";
    description = "Loop based midi sequencer with Qt GUI derived from seq24 and sequencer64";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "qseq66";
    platforms = lib.platforms.linux;
  };
})
