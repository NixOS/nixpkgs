{ stdenv, fetchurl, fetchbzr, unzip, cmake, mesa, gtk, wxGTK, zlib, libX11, 
gettext, cups } : 

stdenv.mkDerivation rec {
  name = "kicad-20130325";

  src = fetchurl {
    url = "http://iut-tice.ujf-grenoble.fr/cao/kicad-sources-stable_2013-03-25_BZR4005.zip";
    sha256 = "0hg2aiis14am7mmpimcxnxvhy7c7fr5rgzlk6rjv44d9m0f9957m";
  };

  srcLibrary = fetchbzr {
    url = "http://bazaar.launchpad.net/~kicad-lib-committers/kicad/library";
    revision = 220;
    sha256 = "0l2lblgnm51n2w1p4ifpwdvq04rxgq73zrfxlhqa9zdlyh4rcddb";
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
    homepage = "http://www.kicad-pcb.org/";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
