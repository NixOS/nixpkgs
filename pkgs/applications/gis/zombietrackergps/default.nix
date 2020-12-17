{ mkDerivation
, lib
, fetchFromGitLab
, qmake
, qtcharts
, qtsvg
, marble
, qtwebengine
, ldutils
}:

mkDerivation rec {
  pname = "zombietrackergps";
  version = "1.03";

  src = fetchFromGitLab {
    owner = "ldutils-projects";
    repo = pname;
    rev = "v_${version}";
    sha256 = "1rmdy6kijmcxamm4mqmz8638xqisijlnpv8mimgxywpf90h9rrwq";
  };

  buildInputs = [
    ldutils
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
    homepage = "https://www.zombietrackergps.net/ztgps/";
    changelog = "https://www.zombietrackergps.net/ztgps/history.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sohalt ];
    platforms = platforms.linux;
  };
}
