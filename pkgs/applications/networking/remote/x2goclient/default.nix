{ lib
, fetchurl
, cups
, libssh
, libXpm
, nx-libs
, openldap
, openssh
, qt5
, qtbase
, qtsvg
, qtx11extras
, qttools
, phonon
, pkg-config
}:

qt5.mkDerivation rec {
  pname = "x2goclient";
  version = "4.1.2.2";

  src = fetchurl {
    url = "https://code.x2go.org/releases/source/${pname}/${pname}-${version}.tar.gz";
    sha256 = "yZUyZ8QPpnEZrZanO6yx8mYZbaIFnwzc0bjVGZQh0So=";
  };

  buildInputs = [
    cups
    libssh
    libXpm
    nx-libs
    openldap
    openssh
    qtbase
    qtsvg
    qtx11extras
    qttools
    phonon
  ];

  nativeBuildInputs = [
    pkg-config
    qt5.wrapQtAppsHook
  ];

  postPatch = ''
     substituteInPlace src/onmainwindow.cpp --replace "/usr/sbin/sshd" "${openssh}/bin/sshd"
     substituteInPlace Makefile \
       --replace "SHELL=/bin/bash" "SHELL=$SHELL" \
       --replace "lrelease-qt4" "${qttools.dev}/bin/lrelease" \
       --replace "qmake-qt4" "${qtbase.dev}/bin/qmake" \
       --replace "-o root -g root" ""
  '';

  makeFlags = [ "PREFIX=$(out)" "ETCDIR=$(out)/etc" "build_client" "build_man" ];

  installTargets = [ "install_client" "install_man" ];

  qtWrapperArgs = [ "--suffix PATH : ${nx-libs}/bin:${openssh}/libexec" "--set QT_QPA_PLATFORM xcb" ];

  meta = with lib; {
    description = "Graphical NoMachine NX3 remote desktop client";
    homepage = "http://x2go.org/";
    maintainers = with maintainers; [ ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
