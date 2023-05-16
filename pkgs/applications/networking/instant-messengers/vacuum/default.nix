<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchFromGitHub
  , qt4, qmake4Hook, openssl
  , xorgproto, libX11, libXScrnSaver
  , xz, zlib
}:
stdenv.mkDerivation {
  pname = "vacuum-im";
  version = "1.3.0.20160104";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Vacuum-IM";
    repo = "vacuum-im";
<<<<<<< HEAD
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

=======
    rev = "1.3.0.20160104-Alpha";
    sha256 = "1jcw9c7s75y4c3m4skfc3cc0i519z39b23n997vj5mwcjplxyc76";
  };

  buildInputs = [
    qt4 openssl xorgproto libX11 libXScrnSaver xz zlib
  ];

  # hack: needed to fix build issues in
  # https://hydra.nixos.org/build/38322959/nixlog/1
  # should be an upstream issue but it's easy to fix
  NIX_LDFLAGS = "-lz";

  nativeBuildInputs = [ qmake4Hook ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags INSTALL_PREFIX=$out"
  '';

  hardeningDisable = [ "format" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "An XMPP client fully composed of plugins";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl3;
    homepage = "http://www.vacuum-im.org";
  };
}
