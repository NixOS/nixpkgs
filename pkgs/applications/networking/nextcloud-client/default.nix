{ lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, qtbase, qtwebkit, qtkeychain, qttools, sqlite
, inotify-tools, openssl, pcre, qtwebengine, libsecret
, libcloudproviders
}:

mkDerivation rec {
  pname = "nextcloud-client";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "desktop";
    rev = "v${version}";
    sha256 = "1pzlq507fasf2ljf37gkw00qrig4w2r712rsy05zfwlncgcn7fnw";
  };

  patches = [
    ./0001-Explicitly-copy-dbus-files-into-the-store-dir.patch
  ];

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ qtbase qtwebkit qtkeychain qttools qtwebengine sqlite openssl pcre inotify-tools libcloudproviders ];

  qtWrapperArgs = [
    ''--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libsecret ]}''
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
