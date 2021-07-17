{ stdenv
, lib
, fetchFromGitHub
, python3Packages
, cmake
, qt5
, lxqt
}:

stdenv.mkDerivation rec {
  pname = "qtermwidget";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "sha256-aAeW5fPNBu+Z9//rvmGyLrXi4CZeo6bdY+YjtaqYs14=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qt5.full
    lxqt.lxqt-build-tools
    python3Packages.pyqt5
    python3Packages.sip
    python3Packages.sip_4
  ];

  meta = with lib; {
    description = "A terminal widget for Qt, used by QTerminal";
    homepage = "https://github.com/lxqt/qtermwidget";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
