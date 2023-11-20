{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, extra-cmake-modules
, qt6
, qt6Packages
, sqlite
, libsecret
, libre-graph-api-cpp-qt-client
, kdsingleapplication
# darwin only:
, libinotify-kqueue
, sparkleshare
}:

stdenv.mkDerivation rec {
  pname = "owncloud-client";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "owncloud";
    repo = "client";
    rev = "refs/tags/v${version}";
    hash = "sha256-SSMNmWrCT1sGa38oY8P84QNedNkQPcIRWrV9B65B5X8=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    extra-cmake-modules
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    sqlite
    libsecret
    qt6.qtbase
    qt6.qtsvg # Needed for the systray icon
    qt6Packages.qtkeychain
    libre-graph-api-cpp-qt-client
    kdsingleapplication
  ] ++ lib.optionals stdenv.isDarwin [
    libinotify-kqueue sparkleshare
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
