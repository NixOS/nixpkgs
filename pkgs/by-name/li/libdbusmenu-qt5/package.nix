{
  lib,
  stdenv,
  fetchgit,
  cmake,
  libsForQt5,
}:

stdenv.mkDerivation rec {
  pname = "libdbusmenu-qt5";
  version = "0.9.3+16";

  src = fetchgit {
    url = "https://git.launchpad.net/ubuntu/+source/libdbusmenu-qt";
    rev = "import/${version}.04.20160218-1";
    hash = "sha256-nXZv1m/dQv8vt+xPS7WTC8nKfbEJ45WtZ8vVBencPg0=";
  };

  buildInputs = [ libsForQt5.qtbase ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DWITH_DOC=OFF"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  dontWrapQtApps = true;

  meta = {
    homepage = "https://launchpad.net/libdbusmenu-qt";
    description = "Provides a Qt implementation of the DBusMenu spec";
    maintainers = [ lib.maintainers.ttuegel ];
    inherit (libsForQt5.qtbase.meta) platforms;
    license = lib.licenses.lgpl2;
  };
}
