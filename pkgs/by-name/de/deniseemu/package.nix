{
  lib,
  stdenv,
  fetchFromBitbucket,
  cmake,
  freetype,
  pkg-config,
  pulseaudio,
  gtk3,
  libxkbcommon,
  udev,
  libuuid,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deniseemu";
  version = "2.6";

  src = fetchFromBitbucket {
    owner = "piciji";
    repo = "denise";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+PJtYuiZ1eawuVCTo1kqtCmIoBjNKOGRDnbuH3KRpNM=";
  };

  buildInputs = [
    gtk3
    udev
    libuuid
    libxkbcommon
    freetype
    pulseaudio
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  meta = {
    homepage = "https://bitbucket.org/piciji/denise";
    downloadPage = "https://sourceforge.net/projects/deniseemu/";
    description = "C64 / Amiga Emulator";
    license = [ lib.licenses.gpl3Plus ];
    maintainers = [ lib.maintainers.matthewcroughan ];
    platforms = lib.platforms.linux;
  };
})
