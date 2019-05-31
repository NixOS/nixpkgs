{ stdenv, fetchgit, cmake, pkgconfig, qtbase, qtwebkit, qtkeychain, qttools, sqlite
, inotify-tools, makeWrapper, openssl_1_1, pcre, qtwebengine, libsecret, fetchpatch
, libcloudproviders
}:

stdenv.mkDerivation rec {
  name = "nextcloud-client-${version}";
  version = "2.5.2";

  src = fetchgit {
    url = "git://github.com/nextcloud/desktop.git";
    rev = "refs/tags/v${version}";
    sha256 = "1brpxdgyy742dqw6cyyv2257d6ihwiqhbzfk2hb8zjgbi6p9lhsr";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig cmake makeWrapper ];

  buildInputs = [ qtbase qtwebkit qtkeychain qttools qtwebengine sqlite openssl_1_1.out pcre inotify-tools libcloudproviders ];

  enableParallelBuilding = true;

  NIX_LDFLAGS = "${openssl_1_1.out}/lib/libssl.so ${openssl_1_1.out}/lib/libcrypto.so";

  cmakeFlags = [
    "-UCMAKE_INSTALL_LIBDIR"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DOPENSSL_LIBRARIES=${openssl_1_1.out}/lib"
    "-DOPENSSL_INCLUDE_DIR=${openssl_1_1.dev}/include"
    "-DINOTIFY_LIBRARY=${inotify-tools}/lib/libinotifytools.so"
    "-DINOTIFY_INCLUDE_DIR=${inotify-tools}/include"
  ];

  postInstall = ''
    sed -i 's/\(Icon.*\)=nextcloud/\1=Nextcloud/g' \
    $out/share/applications/nextcloud.desktop

    wrapProgram "$out/bin/nextcloud" \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ libsecret ]} \
      --prefix QT_PLUGIN_PATH : ${qtbase}/${qtbase.qtPluginPrefix}
  '';

  meta = with stdenv.lib; {
    description = "Nextcloud themed desktop client";
    homepage = https://nextcloud.com;
    license = licenses.gpl2;
    maintainers = with maintainers; [ caugner ma27 ];
    platforms = platforms.linux;
  };
}
