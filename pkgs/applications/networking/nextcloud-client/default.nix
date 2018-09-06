{ stdenv, fetchgit, cmake, libcloudproviders, libzip, openssl, pcre, pkgconfig
, qtbase, qtdeclarative, qtkeychain, qtsvg, qttools, qtwebengine, sqlite
, inotify-tools, withGnomeKeyring ? false, makeWrapper, libgnome-keyring }:

stdenv.mkDerivation rec {
  name = "nextcloud-client-${version}";
  version = "2.5.0-rc1";

  src = fetchgit {
    url = "https://github.com/nextcloud/desktop.git";
    rev = "58302e9fc0ed9da5eee5c00140069983edfcb957";
    sha256 = "01w0yam9jqa0lyadinyxfcx50q1c94dk8a5fff52n0iy1l1px3vw";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [
      libcloudproviders libzip makeWrapper openssl pcre qtbase qtdeclarative
      qtkeychain qtsvg qttools qtwebengine sqlite
    ]
    ++ stdenv.lib.optional stdenv.isLinux inotify-tools;

  enableParallelBuilding = true;

  dontUseCmakeBuildDir = true;

  cmakeFlags = [
    "-UCMAKE_INSTALL_LIBDIR"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DNO_SHIBBOLETH=1"
    "-DCMAKE_PREFIX_PATH=${cmake}"
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    "-DINOTIFY_LIBRARY=${inotify-tools}/lib/libinotifytools.so"
    "-DINOTIFY_INCLUDE_DIR=${inotify-tools}/include"
  ];

  postInstall = ''
    sed -i 's/\(Icon.*\)=nextcloud/\1=Nextcloud/g' \
      $out/share/applications/nextcloud.desktop

    wrapProgram "$out/bin/nextcloud" \
      ${stdenv.lib.optionalString withGnomeKeyring
        "--prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ libgnome-keyring ]}"} \
      --prefix QT_PLUGIN_PATH : "${qtbase}/${qtbase.qtPluginPrefix}"
  '';

  meta = with stdenv.lib; {
    description = "Desktop Syncing Client for Nextcloud";
    homepage = https://nextcloud.com;
    license = licenses.gpl2;
    maintainers = with maintainers; [ caugner ];
    platforms = platforms.linux;
  };
}
