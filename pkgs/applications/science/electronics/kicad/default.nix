{stdenv, fetchsvn, unzip, cmake, mesa, wxGTK, zlib, libX11}:

stdenv.mkDerivation rec {
  name = "kicad-svn-2518";

  src = fetchsvn {
    url = https://kicad.svn.sourceforge.net/svnroot/kicad/trunk/kicad;
    rev = 2518;
    sha256 = "05z4fnkvvy91d0krf72q8xyislwh3zg8k0gy9w18caizbla5sih5";
  };

  srcLibrary = fetchsvn {
    url = https://kicad.svn.sourceforge.net/svnroot/kicad/trunk/kicad-library;
    rev = 2518;
    sha256 = "05sfmbp1z3hjxzcspj4vpprww5bxc6hq4alcjlc1vg6cvx2qgb9s";
  };

  # They say they only support installs to /usr or /usr/local,
  # so we have to handle this.
  patchPhase = ''
    sed -i -e 's,/usr/local/kicad,'$out,g common/gestfich.cpp
  '';

  enableParallelBuilding = true;

  buildInputs = [ unzip cmake mesa wxGTK zlib libX11 ];

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
