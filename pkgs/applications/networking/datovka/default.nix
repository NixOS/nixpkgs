{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  wrapQtAppsHook,
  libxml2,
  libdatovka,
  qmake,
  qtbase,
  qtwebsockets,
  qtsvg,
}:

stdenv.mkDerivation rec {
  pname = "datovka";
  version = "4.28.0";

  src = fetchurl {
    url = "https://gitlab.nic.cz/datovka/datovka/-/archive/v${version}/datovka-v${version}.tar.gz";
    sha256 = "sha256-vTfmJEwbfaPFnZE8o3YnZhjwfMZ0At7eZ0iMoh4/HQE=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    libdatovka
    qmake
    qtbase
    qtsvg
    libxml2
    qtwebsockets
  ];

  meta = {
    description = "Client application for operating Czech government-provided Databox infomation system";
    homepage = "https://www.datovka.cz/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.mmahut ];
    platforms = lib.platforms.linux;
    mainProgram = "datovka";
  };
}
