{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, inotify-tools
, libcloudproviders
, libsecret
, openssl
, pcre
, pkgconfig
, qtbase
, qtkeychain
, qttools
, qtwebengine
, qtwebkit
, sqlite
}:

mkDerivation rec {
  pname = "nextcloud-client";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "desktop";
    rev = "v${version}";
    sha256 = "18318j488pxksf4zc6zag8pdpyaks55yivn91nx3x458ax6albkz";
  };

  patches = [
    ./0001-Explicitly-copy-dbus-files-into-the-store-dir.patch
  ];

  nativeBuildInputs = [
    pkgconfig
    cmake
  ];

  buildInputs = [
    inotify-tools
    libcloudproviders
    openssl
    pcre
    qtbase
    qtkeychain
    qttools
    qtwebengine
    qtwebkit
    sqlite
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libsecret ]}"
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib" # expected to be prefix-relative by build code setting RPATH
  ];

  meta = with lib; {
    description = "Nextcloud themed desktop client";
    homepage = https://nextcloud.com;
    license = licenses.gpl2;
    maintainers = with maintainers; [ caugner ma27 ];
    platforms = platforms.linux;
  };
}
