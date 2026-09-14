{
  stdenv,
  lib,
  fetchFromSourcehut,
  meson,
  ninja,
  pkg-config,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bfcal";
  version = "1.0.1";

  src = fetchFromSourcehut {
    owner = "~bitfehler";
    repo = "bfcal";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5xyBU+0XUNFUGgvw7U8YE64zncw6SvPmbJhc1LY2u/g=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
  ];

  meta = {
    description = "Quickly display a calendar";
    mainProgram = "bfcal";
    homepage = "https://git.sr.ht/~bitfehler/bfcal";
    license = lib.licenses.gpl3Plus;
    platforms = libsForQt5.qtbase.meta.platforms;
    maintainers = with lib.maintainers; [ laalsaas ];
  };
})
