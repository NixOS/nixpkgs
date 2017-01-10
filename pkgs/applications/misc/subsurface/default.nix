{
  stdenv,
  cmake,
  curl,
  fetchgit,
  grantlee,
  libdivecomputer,
  libgit2,
  libmarble-ssrf,
  libssh2,
  libxml2,
  libxslt,
  libzip,
  pkgconfig,
  qtbase,
  qtconnectivity,
  qttools,
  qtwebkit,
  sqlite
}:

stdenv.mkDerivation rec {
  version = "4.5.97";
  name = "subsurface-${version}";

  src = fetchgit {
    sha256 = "035ywhicadmr9sh7zhfxsvpchwa9sywccacbspfam39n2hpyqnmm";
    url = "git://git.subsurface-divelog.org/subsurface";
    rev = "72bcb6481f3b935444d7868a74599dda133f9b43";
    branchName = "master";
  };

  buildInputs = [ qtbase libdivecomputer libmarble-ssrf libxslt
                  libzip libxml2 grantlee qtwebkit qttools
                  qtconnectivity libgit2 libssh2 curl ];
  nativeBuildInputs = [ pkgconfig cmake ];

  #enableParallelBuilding = true; # fatal error: ui_mainwindow.h: No such file or directory

  # hack incoming...
  preConfigure = ''
    marble_libs=$(echo $(echo $CMAKE_LIBRARY_PATH | grep -o "/nix/store/[[:alnum:]]*-libmarble-ssrf-[a-zA-Z0-9\-]*/lib")/libssrfmarblewidget.so)
    cmakeFlags="$cmakeFlags -DCMAKE_BUILD_TYPE=Debug \
                            -DMARBLE_LIBRARIES=$marble_libs \
                            -DNO_PRINTING=OFF"
  '';

  meta = with stdenv.lib; {
    description = "Subsurface is an open source divelog program that runs on Windows, Mac and Linux";
    longDescription = ''
      Subsurface can track single- and multi-tank dives using air, Nitrox or TriMix.
      It allows tracking of dive locations including GPS coordinates (which can also
      conveniently be entered using a map interface), logging of equipment used and
      names of other divers, and lets users rate dives and provide additional notes.
    '';
    homepage = https://subsurface-divelog.org;
    license = licenses.gpl2;
    maintainers = [ maintainers.mguentner ];
    platforms = platforms.all;
  };

}
