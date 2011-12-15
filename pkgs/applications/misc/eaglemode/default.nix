{ stdenv, fetchurl, perl, libX11, xineLib, libjpeg, libpng, libtiff, pkgconfig,
librsvg, glib, gtk, libXext, libXxf86vm, poppler }:

stdenv.mkDerivation {
  name = "eaglemode-0.83.0";
 
  src = fetchurl {
    url = mirror://sourceforge/eaglemode/eaglemode-0.83.0.tar.bz2;
    sha256 = "0rlvi9ljf3ml2l4ydkcgjjja8wk9c7h5qlpdr4x4ghh6sqq0q2x3";
  };
 
  buildInputs = [ perl libX11 xineLib libjpeg libpng libtiff pkgconfig 
    librsvg glib gtk libXxf86vm libXext poppler ];
 
  # The program tries to dlopen both Xxf86vm and Xext, so we use the
  # trick on NIX_LDFLAGS and dontPatchELF to make it find them.
  buildPhase = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lXxf86vm -lXext"
    yes n | perl make.pl build
  '';

  dontPatchELF = true;

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
