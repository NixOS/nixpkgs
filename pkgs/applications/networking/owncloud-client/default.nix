{ lib
, stdenv
, fetchFromGitHub
, mkDerivation
, pkg-config
, cmake
, extra-cmake-modules
, callPackage
, qtbase
, qtkeychain
, wrapQtAppsHook
, qttools
, sqlite
, libsecret
}:

stdenv.mkDerivation rec {
  pname = "owncloud-client";
<<<<<<< HEAD
  version = "4.2.0";
=======
  version = "3.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  libregraph = callPackage ./libre-graph-api-cpp-qt-client.nix { };

  src = fetchFromGitHub {
    owner = "owncloud";
    repo = "client";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-dPNVp5DxCI4ye8eFjHoLGDlf8Ap682o1UB0k2VNr2rs=";
=======
    hash = "sha256-39tpvzlTy3KRxg8DzCQW2VnsaLqJ+dNQRur2TqRZytE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config cmake extra-cmake-modules wrapQtAppsHook qttools ];
  buildInputs = [ qtbase qtkeychain sqlite libsecret libregraph ];

  cmakeFlags = [
    "-UCMAKE_INSTALL_LIBDIR"
    "-DNO_SHIBBOLETH=1"
<<<<<<< HEAD
=======
    # https://github.com/owncloud/client/issues/10537#issuecomment-1447965096
    # NB! From 4.0 it may be turned off by default
    "-DWITH_AUTO_UPDATER=OFF"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Synchronise your ownCloud with your computer using this desktop client";
    homepage = "https://owncloud.org";
    maintainers = with maintainers; [ qknight hellwolf ];
    platforms = platforms.unix;
<<<<<<< HEAD
    broken = stdenv.isDarwin;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl2Plus;
    changelog = "https://github.com/owncloud/client/releases/tag/v${version}";
  };
}
