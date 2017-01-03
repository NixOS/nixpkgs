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
    sha256 = "0mbf8m5sbimbyvlh65sjlydrycr4ssfyfzdlqyl0wcpzw7h0qfp8";
    url = "git://git.subsurface-divelog.org/subsurface";
    rev = "5f15ad5a86ada3c5e574041a5f9d85235322dabb";
    branchName = "master";
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
