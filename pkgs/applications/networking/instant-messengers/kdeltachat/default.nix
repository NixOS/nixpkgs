{ lib
, mkDerivation
, fetchFromSourcehut
, cmake
, extra-cmake-modules
, pkg-config
, kirigami2
, libdeltachat
, qtbase
, qtimageformats
, qtmultimedia
, qtwebengine
}:

mkDerivation rec {
  pname = "kdeltachat";
  version = "unstable-2024-01-14";

  src = fetchFromSourcehut {
    owner = "~link2xt";
    repo = "kdeltachat";
    rev = "d61a01c2d6d5bdcc9ca500b466ed42689b2bd5c6";
    hash = "sha256-KmL3ODXPi1c8C5z2ySHg0vA5Vg/dZumDZTbpxkzf7A4=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    kirigami2
    libdeltachat
    qtimageformats
    qtmultimedia
    qtwebengine
  ];

  # needed for qmlplugindump to work
  QT_PLUGIN_PATH = "${qtbase.bin}/${qtbase.qtPluginPrefix}";
  QML2_IMPORT_PATH = lib.concatMapStringsSep ":"
    (lib: "${lib}/${qtbase.qtQmlPrefix}")
    [ kirigami2 qtmultimedia ];

  meta = with lib; {
    description = "Delta Chat client using Kirigami framework";
    homepage = "https://git.sr.ht/~link2xt/kdeltachat";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
