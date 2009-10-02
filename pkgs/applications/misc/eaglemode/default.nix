{ stdenv, fetchurl, perl, libX11, xineLib, libjpeg, libpng, libtiff }:

stdenv.mkDerivation {
  name = "eaglemode-0.75";
 
  src = fetchurl {
    url = mirror://sourceforge/eaglemode/eaglemode-0.75.0.tar.bz2;
    sha256 = "0iqdf55ff0il5frkl3yq3r27yk9xl30b9ygf3fvrv78a5bzpq8r7";
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
    maintainersv = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
