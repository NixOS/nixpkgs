{ lib, mkDerivation, fetchFromSourcehut, cmake, extra-cmake-modules, pkg-config
, kirigami2, libdeltachat, qtbase, qtimageformats, qtmultimedia, qtwebengine }:

mkDerivation rec {
  pname = "kdeltachat";
  version = "unstable-2021-11-14";

  src = fetchFromSourcehut {
    owner = "~link2xt";
    repo = "kdeltachat";
    rev = "796b5ce8a11e294e6325dbe92cd1834d140368ff";
    hash = "sha256-Zjh83TrAm9pWieqz1e+Wzoy6g/xfsjhI/3Ll73iJoD4=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config ];

  buildInputs =
    [ kirigami2 libdeltachat qtimageformats qtmultimedia qtwebengine ];

  # needed for qmlplugindump to work
  QT_PLUGIN_PATH = "${qtbase.bin}/${qtbase.qtPluginPrefix}";
  QML2_IMPORT_PATH =
    lib.concatMapStringsSep ":" (lib: "${lib}/${qtbase.qtQmlPrefix}") [
      kirigami2
      qtmultimedia
    ];

  meta = with lib; {
    description = "Delta Chat client using Kirigami framework";
    homepage = "https://git.sr.ht/~link2xt/kdeltachat";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
