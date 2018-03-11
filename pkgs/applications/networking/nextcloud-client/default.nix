{ stdenv, fetchgit, cmake, pkgconfig, qtbase, qtwebkit, qtkeychain, qttools, sqlite
, inotify-tools, withGnomeKeyring ? false, makeWrapper, libgnome-keyring }:

stdenv.mkDerivation rec {
  name = "nextcloud-client-${version}";
  version = "2.3.3";

  src = fetchgit {
    url = "git://github.com/nextcloud/client_theming.git";
    rev = "ab40efe1e1475efddd636c09251d8917627261da";
    sha256 = "19a1kqydgx47sa1a917j46zlbc5g9nynsanasyad9c8sqi0qvyip";
    fetchSubmodules = true;
  };

  patches = [ ./find-sql.patch ];
  patchFlags = "-d client -p1";

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ qtbase qtwebkit qtkeychain qttools sqlite ]
    ++ stdenv.lib.optional stdenv.isLinux inotify-tools
    ++ stdenv.lib.optional withGnomeKeyring makeWrapper;

  enableParallelBuilding = true;

  dontUseCmakeBuildDir = true;

  cmakeDir = "client";

  cmakeFlags = [
    "-UCMAKE_INSTALL_LIBDIR"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DOEM_THEME_DIR=${src}/nextcloudtheme"
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    "-DINOTIFY_LIBRARY=${inotify-tools}/lib/libinotifytools.so"
    "-DINOTIFY_INCLUDE_DIR=${inotify-tools}/include"
  ];

  postInstall = ''
    sed -i 's/\(Icon.*\)=nextcloud/\1=Nextcloud/g' \
      $out/share/applications/nextcloud.desktop
  '' + stdenv.lib.optionalString (withGnomeKeyring) ''
    wrapProgram "$out/bin/nextcloud" \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ libgnome-keyring ]}
  '';

  meta = with stdenv.lib; {
    description = "Nextcloud themed desktop client";
    homepage = https://nextcloud.com;
    license = licenses.gpl2;
    maintainers = with maintainers; [ caugner ];
    platforms = platforms.unix;
  };
}
