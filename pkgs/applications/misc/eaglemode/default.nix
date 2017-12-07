{ stdenv, fetchurl, perl, libX11, libjpeg, libpng, libtiff, pkgconfig,
librsvg, glib, gtk2, libXext, libXxf86vm, poppler, xineLib }:

stdenv.mkDerivation rec {
  name = "eaglemode-0.86.0";

  src = fetchurl {
    url = "mirror://sourceforge/eaglemode/${name}.tar.bz2";
    sha256 = "1a2hzyck95g740qg4p4wd4fjwsmlknh75i9sbx5r5v9pyr4i3m4f";
  };

  buildInputs = [ perl libX11 libjpeg libpng libtiff pkgconfig
    librsvg glib gtk2 libXxf86vm libXext poppler xineLib ];

  # The program tries to dlopen both Xxf86vm and Xext, so we use the
  # trick on NIX_LDFLAGS and dontPatchELF to make it find them.
  # I use 'yes y' to skip a build error linking with xineLib,
  # because xine stopped exporting "_x_vo_new_port"
  #  http://sourceforge.net/projects/eaglemode/forums/forum/808824/topic/5115261
  buildPhase = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lXxf86vm -lXext"
    perl make.pl build
  '';

  dontPatchELF = true;

  installPhase = ''
    perl make.pl install dir=$out
    # I don't like this... but it seems the way they plan to run it by now.
    # Run 'eaglemode.sh', not 'eaglemode'.
    ln -s $out/eaglemode.sh $out/bin/eaglemode.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://eaglemode.sourceforge.net;
    description = "Zoomable User Interface";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
