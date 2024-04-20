{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, inotify-tools
, libcloudproviders
, librsvg
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
, xdg-utils
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "nextcloud-client";
  version = "3.12.3";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "desktop";
    rev = "v${version}";
    hash = "sha256-ScWkEOx2tHoCQbFwBvJQgk2YoYOTPi3PrVsaDNJBEUI=";
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
    librsvg
    sphinx
    wrapQtAppsHook
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
    # make xdg-open overrideable at runtime
    "--suffix PATH : ${lib.makeBinPath [ xdg-utils ]}"
  ];

  cmakeFlags = [
    "-DBUILD_UPDATER=off"
    "-DCMAKE_INSTALL_LIBDIR=lib" # expected to be prefix-relative by build code setting RPATH
    "-DMIRALL_VERSION_SUFFIX=" # remove git suffix from version
  ];

  postBuild = ''
    make doc-man
  '';

  meta = with lib; {
    description = "Nextcloud themed desktop client";
    homepage = "https://nextcloud.com";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kranzes SuperSandro2000 ];
    platforms = platforms.linux;
    mainProgram = "nextcloud";
  };
}
