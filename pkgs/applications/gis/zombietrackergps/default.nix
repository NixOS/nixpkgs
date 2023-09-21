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
  version = "1.10";

  src = fetchFromGitLab {
    owner = "ldutils-projects";
    repo = pname;
    rev = "v_${version}";
    sha256 = "sha256-qRhCAOVWyDLD3WDptPRQVq+VwyFu83XQNaL5TMsGs4Y=";
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
    substituteInPlace ztgps.pro --replace "../libldutils" "libldutils"
    substituteInPlace tests.pro --replace "../libldutils" "libldutils"

    ln -s ${ldutils} libldutils
  '';

  preConfigure = ''
    export LANG=en_US.UTF-8
    export INSTALL_ROOT=$out
  '';

  preInstall = ''
    substituteInPlace Makefile.ztgps --replace '$(INSTALL_ROOT)' ""
    substituteInPlace Makefile.art --replace '$(INSTALL_ROOT)' ""
  '';

  postInstall = ''
    install -Dm644 build/rcc/*.rcc -t $out/share/zombietrackergps
  '';

  qmakeFlags = [ "ZombieTrackerGPS.pro" ];

  meta = with lib; {
    description = "GPS track manager for Qt using KDE Marble maps";
    homepage = "https://www.zombietrackergps.net/ztgps/";
    changelog = "https://www.zombietrackergps.net/ztgps/history.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sohalt ];
    platforms = platforms.linux;
    broken = true;  # doesn't build with latest Marble
  };
}
