{ mkDerivation
, lib
, fetchFromGitLab
, qmake
, qtbase
, qtcharts
, qtsvg
, marble
, qtwebengine
, ldutils
}:

mkDerivation rec {
  pname = "zombietrackergps";
  version = "1.01";

  src = fetchFromGitLab {
    owner = "ldutils-projects";
    repo = pname;
    rev = "v_${version}";
    sha256 = "0h354ydbahy8rpkmzh5ym5bddbl6irjzklpcg6nbkv6apry84d48";
  };

  buildInputs = [
    ldutils
    qtbase
    qtcharts
    qtsvg
    marble.dev
    qtwebengine
  ];

  nativeBuildInputs = [
    qmake
  ];

  prePatch = ''
    sed -ie "s,INCLUDEPATH += /usr/include/libldutils,INCLUDEPATH += ${ldutils}," ZombieTrackerGPS.pro
  '';

  preConfigure = ''
    export LANG=en_US.UTF-8
    export INSTALL_ROOT=$out
  '';

  postConfigure = ''
    substituteInPlace Makefile --replace '$(INSTALL_ROOT)' ""
  '';

  meta = with lib; {
    description = "GPS track manager for Qt using KDE Marble maps";
    homepage = "https://gitlab.com/ldutils-projects/zombietrackergps";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sohalt ];
    platforms = platforms.linux;
  };
}
