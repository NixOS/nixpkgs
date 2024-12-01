{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, inotify-tools
, kdePackages
, libcloudproviders
, librsvg
, libsecret
, openssl
, pcre
, pkg-config
, qt5compat
, qtbase
, qtkeychain
, qtsvg
, qttools
, qtwebengine
, qtwebsockets
, sphinx
, sqlite
, xdg-utils
, qtwayland
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "nextcloud-client";
  version = "3.14.3";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "nextcloud-releases";
    repo = "desktop";
    rev = "refs/tags/v${version}";
    hash = "sha256-nYoBs5EnWiqYRsqc5CPxCIs0NAxSprI9PV0lO/c8khw=";
  };

  patches = [
    # Explicitly move dbus configuration files to the store path rather than `/etc/dbus-1/services`.
    ./0001-Explicitly-copy-dbus-files-into-the-store-dir.patch
    ./0001-When-creating-the-autostart-entry-do-not-use-an-abso.patch
  ];

  postPatch = ''
    for file in src/libsync/vfs/*/CMakeLists.txt; do
      substituteInPlace $file \
        --replace-fail "PLUGINDIR" "KDE_INSTALL_PLUGINDIR"
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
    kdePackages.kio
    libcloudproviders
    libsecret
    openssl
    pcre
    qt5compat
    qtbase
    qtkeychain
    qtsvg
    qttools
    qtwebengine
    qtwebsockets
    sqlite
    qtwayland
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
    changelog = "https://github.com/nextcloud/desktop/releases/tag/v${version}";
    description = "Desktop sync client for Nextcloud";
    homepage = "https://nextcloud.com";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kranzes SuperSandro2000 ];
    platforms = platforms.linux;
    mainProgram = "nextcloud";
  };
}
