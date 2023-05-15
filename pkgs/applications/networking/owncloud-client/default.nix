{ lib
, fetchFromGitHub
, mkDerivation
, pkg-config
, cmake
, extra-cmake-modules
, callPackage
, qtbase
, qtkeychain
, qttools
, sqlite
, libsecret
}:

mkDerivation rec {
  pname = "owncloud-client";
  version = "4.0.0";

  libregraph = callPackage ./libre-graph-api-cpp-qt-client.nix { };

  src = fetchFromGitHub {
    owner = "owncloud";
    repo = "client";
    rev = "refs/tags/v${version}";
    hash = "sha256-KZ/e8ISQ4FNgT/mtKSlOCa3WQ0lRSaqNIhQn6al6NSM=";
  };

  nativeBuildInputs = [ pkg-config cmake extra-cmake-modules ];
  buildInputs = [ qtbase qttools qtkeychain sqlite libsecret libregraph ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libsecret ]}"
  ];

  cmakeFlags = [
    "-UCMAKE_INSTALL_LIBDIR"
    "-DNO_SHIBBOLETH=1"
  ];

  meta = with lib; {
    description = "Synchronise your ownCloud with your computer using this desktop client";
    homepage = "https://owncloud.org";
    maintainers = with maintainers; [ qknight hellwolf ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    changelog = "https://github.com/owncloud/client/releases/tag/v${version}";
  };
}
