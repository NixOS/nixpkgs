{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxml2,
  libdatovka,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "datovka";
  version = "4.28.0";

  src = fetchurl {
    url = "https://gitlab.nic.cz/datovka/datovka/-/archive/v${finalAttrs.version}/datovka-v${finalAttrs.version}.tar.gz";
    hash = "sha256-vTfmJEwbfaPFnZE8o3YnZhjwfMZ0At7eZ0iMoh4/HQE=";
  };

  nativeBuildInputs = [
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libdatovka
    libsForQt5.qmake
    libsForQt5.qtbase
    libsForQt5.qtsvg
    libxml2
    libsForQt5.qtwebsockets
  ];

  meta = {
    description = "Client application for operating Czech government-provided Databox infomation system";
    homepage = "https://www.datovka.cz/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.mmahut ];
    platforms = lib.platforms.linux;
    mainProgram = "datovka";
  };
})
