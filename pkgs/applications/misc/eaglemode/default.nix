{ stdenv, fetchurl, perl, libX11, xineLib, libjpeg, libpng, libtiff }:

stdenv.mkDerivation {
  name = "eaglemode-0.76.0";
 
  src = fetchurl {
    url = mirror://sourceforge/eaglemode/eaglemode-0.76.0.tar.bz2;
    sha256 = "152v7p9dicm8shwncpcifg4b2l4c61c1qn00469cz38vja67npww";
  };
 
  buildInputs = [ perl libX11 xineLib libjpeg libpng libtiff ];
 
  buildPhase = ''
    yes n | perl make.pl build
  '';
  installPhase = ''
    perl make.pl install dir=$out
    # I don't like this... but it seems the way they plan to run it by now.
    # Run 'eaglemode.sh', not 'eaglemode'.
    ln -s $out/eaglemode.sh $out/bin/eaglemode.sh
  '';
 
  meta = {
    homepage = "http://eaglemode.sourceforge.net";
    description = "Zoomable User Interface";
    license="GPLv3";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
