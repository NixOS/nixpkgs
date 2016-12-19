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
  version = "4.5.6";
  name = "subsurface-${version}";

  # use fetchgit instead of the official tgz is not complete
  src = fetchgit {
    sha256 = "156rqcszy0c4plk2mv7wdd4h7s7mygpq5sdc64pjfs4qvvsdj10f";
    url = "git://git.subsurface-divelog.org/subsurface";
    rev = "4d8d7c2a0fa1b4b0e6953d92287c75b6f97472d0";
    branchName = "v4.5-branch";
  };

  buildInputs = [ qtbase libdivecomputer libmarble-ssrf libxslt
                  libzip libxml2 grantlee qtwebkit qttools
                  qtconnectivity libgit2 libssh2 curl ];
  nativeBuildInputs = [ pkgconfig cmake ];

  enableParallelBuilding = true;

  # hack incoming...
  preConfigure = ''
    marble_libs=$(echo $(echo $CMAKE_LIBRARY_PATH | grep -o "/nix/store/[[:alnum:]]*-libmarble-ssrf-[a-zA-Z0-9\-]*/lib")/libssrfmarblewidget.so)
    cmakeFlags="$cmakeFlags -DCMAKE_BUILD_TYPE=Debug \
                            -DMARBLE_LIBRARIES=$marble_libs \
                            -DNO_PRINTING=OFF \
                            -DUSE_LIBGIT23_API=1"
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
