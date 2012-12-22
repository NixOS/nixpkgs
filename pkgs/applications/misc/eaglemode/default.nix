{ stdenv, fetchurl, perl, libX11, libjpeg, libpng, libtiff, pkgconfig,
librsvg, glib, gtk, libXext, libXxf86vm, poppler }:

stdenv.mkDerivation {
  name = "eaglemode-0.84.0";

  src = fetchurl {
    url = mirror://sourceforge/eaglemode/eaglemode-0.84.0.tar.bz2;
    sha256 = "0n20b419j0l7h7jr4s3f3n09ka0ysg9nqs8mcwsrx24rcq7nv0cs";
  };

  buildInputs = [ perl libX11 libjpeg libpng libtiff pkgconfig
    librsvg glib gtk libXxf86vm libXext poppler ];

  # The program tries to dlopen both Xxf86vm and Xext, so we use the
  # trick on NIX_LDFLAGS and dontPatchELF to make it find them.
  # I use 'yes y' to skip a build error linking with xineLib,
  # because xine stopped exporting "_x_vo_new_port"
  #  http://sourceforge.net/projects/eaglemode/forums/forum/808824/topic/5115261
  buildPhase = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lXxf86vm -lXext"
    yes y | perl make.pl build
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
