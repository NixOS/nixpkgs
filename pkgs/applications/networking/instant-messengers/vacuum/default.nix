{ stdenv, lib, fetchFromGitHub
, qtbase
, qttools
, qtx11extras
, qtmultimedia
, qtwebkit
, wrapQtAppsHook
, cmake
, openssl
, xorgproto, libX11, libXScrnSaver
, xz, zlib
}:
stdenv.mkDerivation {
  pname = "vacuum-im";
  version = "unstable-2021-12-09";

  src = fetchFromGitHub {
    owner = "Vacuum-IM";
    repo = "vacuum-im";
    rev = "0abd5e11dd3e2538b8c47f5a06febedf73ae99ee";
    sha256 = "0l9pln07zz874m1r6wnpc9vcdbpgvjdsy49cjjilc6s4p4b2c812";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
  ];
  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtmultimedia
    qtwebkit
    openssl
    xorgproto
    libX11
    libXScrnSaver
    xz
    zlib
  ];

  meta = with lib; {
    description = "XMPP client fully composed of plugins";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl3;
    homepage = "http://www.vacuum-im.org";
  };
}
