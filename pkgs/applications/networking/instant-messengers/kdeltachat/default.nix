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
  version = "unstable-2021-09-10";

  src = fetchFromSourcehut {
    owner = "~link2xt";
    repo = "kdeltachat";
    rev = "40092aa096bac7e279eb5a4cc97758bac484236c";
    sha256 = "0vmsbxx4hxh35v1lbj82vq2w8z8inj83xpf24wzlbdr9inlbmym4";
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
