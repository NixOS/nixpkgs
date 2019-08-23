{ lib, mkDerivation, fetchgit, cmake, pkgconfig, qtbase, qtwebkit, qtkeychain, qttools, sqlite
, inotify-tools, openssl, pcre, qtwebengine, libsecret
, libcloudproviders
}:

mkDerivation rec {
  name = "nextcloud-client-${version}";
  version = "2.5.3";

  src = fetchgit {
    url = "git://github.com/nextcloud/desktop.git";
    rev = "refs/tags/v${version}";
    sha256 = "0fbw56bfbyk3cqv94iqfsxjf01dwy1ysjz89dri7qccs65rnjswj";
    fetchSubmodules = true;
  };

  patches = [
    ./0001-Explicitly-copy-dbus-files-into-the-store-dir.patch
  ];

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ qtbase qtwebkit qtkeychain qttools qtwebengine sqlite openssl.out pcre inotify-tools libcloudproviders ];

  enableParallelBuilding = true;

  NIX_LDFLAGS = "${openssl.out}/lib/libssl.so ${openssl.out}/lib/libcrypto.so";

  cmakeFlags = [
    "-UCMAKE_INSTALL_LIBDIR"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DOPENSSL_LIBRARIES=${openssl.out}/lib"
    "-DOPENSSL_INCLUDE_DIR=${openssl.dev}/include"
    "-DINOTIFY_LIBRARY=${inotify-tools}/lib/libinotifytools.so"
    "-DINOTIFY_INCLUDE_DIR=${inotify-tools}/include"
  ];

  qtWrapperArgs = [
    ''--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libsecret ]}''
  ];

  postInstall = ''
    sed -i 's/\(Icon.*\)=nextcloud/\1=Nextcloud/g' \
    $out/share/applications/nextcloud.desktop
  '';

  meta = with lib; {
    description = "Nextcloud themed desktop client";
    homepage = https://nextcloud.com;
    license = licenses.gpl2;
    maintainers = with maintainers; [ caugner ma27 ];
    platforms = platforms.linux;
  };
}
