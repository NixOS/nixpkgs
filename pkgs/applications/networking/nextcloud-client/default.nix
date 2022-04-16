{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, inotify-tools
, installShellFiles
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
, plasma5Packages
, sphinx
, sqlite
, inkscape
, xdg-utils
}:

mkDerivation rec {
  pname = "nextcloud-client";
  version = "3.4.4";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "desktop";
    rev = "v${version}";
    sha256 = "sha256-e4me4mpK0N3UyM5MuJP3jxwM5h1dGBd+JzAr5f3BOGQ=";
  };

  patches = [
    # Explicitly move dbus configuration files to the store path rather than `/etc/dbus-1/services`.
    ./0001-Explicitly-copy-dbus-files-into-the-store-dir.patch
    ./0001-When-creating-the-autostart-entry-do-not-use-an-abso.patch
  ];

  postPatch = ''
    for file in src/libsync/vfs/*/CMakeLists.txt; do
      substituteInPlace $file \
        --replace "PLUGINDIR" "KDE_INSTALL_PLUGINDIR"
    done
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    extra-cmake-modules
    inkscape
    sphinx
  ];

  buildInputs = [
    inotify-tools
    libcloudproviders
    libsecret
    openssl
    pcre
    plasma5Packages.kio
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
    # See also: https://bugreports.qt.io/browse/QTBUG-85967
    "--set QML_DISABLE_DISK_CACHE 1"
    "--prefix PATH : ${lib.makeBinPath [ xdg-utils ]}"
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib" # expected to be prefix-relative by build code setting RPATH
    "-DNO_SHIBBOLETH=1" # allows to compile without qtwebkit
  ];

  postBuild = ''
    make doc-man
  '';

  meta = with lib; {
    description = "Nextcloud themed desktop client";
    homepage = "https://nextcloud.com";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kranzes ];
    platforms = platforms.linux;
  };
}
