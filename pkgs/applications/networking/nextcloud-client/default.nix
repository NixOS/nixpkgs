{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, inotify-tools
, libcloudproviders
, libsecret
, openssl
, pcre
, pkg-config
, qtbase
, qtkeychain
, qttools
, qtwebengine
, qtwebsockets
, qtquickcontrols2
, qtgraphicaleffects
, sqlite
, inkscape
}:

mkDerivation rec {
  pname = "nextcloud-client";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "desktop";
    rev = "v${version}";
    sha256 = "sha256-kqNN9P0G/Obi/8PStmLxImQdqkhLnJoFZ7dLpqe11TI=";
  };

  patches = [
    # Explicitly move dbus configuration files to the store path rather than `/etc/dbus-1/services`.
    ./0001-Explicitly-copy-dbus-files-into-the-store-dir.patch
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    inkscape
  ];

  buildInputs = [
    inotify-tools
    libcloudproviders
    libsecret
    openssl
    pcre
    qtbase
    qtkeychain
    qttools
    qtwebengine
    qtquickcontrols2
    qtgraphicaleffects
    qtwebsockets
    sqlite
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libsecret ]}"
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib" # expected to be prefix-relative by build code setting RPATH
    "-DNO_SHIBBOLETH=1" # allows to compile without qtwebkit
  ];

  meta = with lib; {
    description = "Nextcloud themed desktop client";
    homepage = "https://nextcloud.com";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ caugner kranzes ];
    platforms = platforms.linux;
  };
}
