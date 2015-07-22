{ stdenv, fetchurl, fetchbzr, cmake, mesa, wxGTK, zlib, libX11, gettext }:

stdenv.mkDerivation rec {
  name = "kicad-20131025";

  src = fetchbzr {
    url = "https://code.launchpad.net/kicad/stable";
    rev = 4024;
    sha256 = "1sv1l2zpbn6439ccz50p05hvqg6j551aqra551wck9h3929ghly5";
  };

  srcLibrary = fetchbzr {
    url = "http://bazaar.launchpad.net/~kicad-product-committers/kicad/library";
    rev = 293;
    sha256 = "1wn9a4nhqyjzzfkq6xm7ag8n5n10xy7gkq6i7yry7wxini7pzv1i";
  };

  cmakeFlags = "-DKICAD_STABLE_VERSION=ON";

  # They say they only support installs to /usr or /usr/local,
  # so we have to handle this.
  patchPhase = ''
    sed -i -e 's,/usr/local/kicad,'$out,g common/gestfich.cpp
  '';

  #enableParallelBuilding = true; # often fails on Hydra: fatal error: pcb_plot_params_lexer.h: No such file or directory

  buildInputs = [ cmake mesa wxGTK zlib libX11 gettext ];

  postInstall = ''
    mkdir library
    cd library
    cmake -DCMAKE_INSTALL_PREFIX=$out $srcLibrary
    make install
  '';

  meta = {
    description = "Free Software EDA Suite";
    homepage = "http://www.kicad-pcb.org/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
