{ stdenv, fetchgit, cmake, pkgconfig, qtbase, qtwebkit, qtkeychain, qttools, sqlite
, inotify-tools, makeWrapper, openssl_1_1, pcre, qtwebengine, libsecret, fetchpatch
}:

stdenv.mkDerivation rec {
  name = "nextcloud-client-${version}";
  version = "2.5.1";

  src = fetchgit {
    url = "git://github.com/nextcloud/desktop.git";
    rev = "refs/tags/v${version}";
    sha256 = "0r6jj3vbmwh7ipv83c8w1b25pbfq3mzrjgcijdw2gwfxwx9pfq7d";
    fetchSubmodules = true;
  };

  # Patch contained in next (>2.5.1) release
  patches = [
    (fetchpatch {
     name = "fix-qt-5.12-build";
     url = "https://github.com/nextcloud/desktop/commit/071709ab5e3366e867dd0b0ea931aa7d6f80f528.patch";
     sha256 = "14k635jwm8hz6i22lz88jj2db8v5czwa3zg0667i4hwhkqqmy61n";
     })
  ];

  nativeBuildInputs = [ pkgconfig cmake makeWrapper ];

  buildInputs = [ qtbase qtwebkit qtkeychain qttools qtwebengine sqlite openssl_1_1.out pcre inotify-tools ];

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
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ libsecret ]}
  '';

  meta = with stdenv.lib; {
    description = "Nextcloud themed desktop client";
    homepage = https://nextcloud.com;
    license = licenses.gpl2;
    maintainers = with maintainers; [ caugner ma27 ];
    platforms = platforms.linux;
  };
}
