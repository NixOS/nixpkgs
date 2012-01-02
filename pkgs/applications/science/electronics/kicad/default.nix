{stdenv, fetchurl, fetchbzr, unzip, cmake, mesa, wxGTK, zlib, libX11,
gettext}:

stdenv.mkDerivation rec {
  name = "kicad-20110708";

  src = fetchurl {
    url = ftp://iut-tice.ujf-grenoble.fr/cao/sources/kicad_sources-2011-07-08-BZR3044.zip;
    sha256 = "1gr75zcf55p3xpbg1gdkdpbh5x11bawc9rcff4fskwjyc3vfiv6a";
  };

  srcLibrary = fetchbzr {
    url = "http://bazaar.launchpad.net/~kicad-lib-committers/kicad/library";
    revision = 112;
    sha256 = "49fa9ad90759cfaf522c2a62665f033688b9d84d02f31c6b2505c08a217ad312";
  };

  cmakeFlags = "-DKICAD_TESTING_VERSION=ON";

  # They say they only support installs to /usr or /usr/local,
  # so we have to handle this.
  patchPhase = ''
    sed -i -e 's,/usr/local/kicad,'$out,g common/gestfich.cpp
  '';

  enableParallelBuilding = true;

  buildInputs = [ unzip cmake mesa wxGTK zlib libX11 gettext ];

  postInstall = ''
    mkdir library
    cd library
    cmake -DCMAKE_INSTALL_PREFIX=$out $srcLibrary
    make install
  '';

  meta = {
    description = "Free Software EDA Suite";
    homepage = http://kicad.sourceforge.net;
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
