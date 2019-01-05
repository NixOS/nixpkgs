{ stdenv, fetchurl, perl, libX11, libXinerama, libjpeg, libpng, libtiff, pkgconfig,
librsvg, glib, gtk2, libXext, libXxf86vm, poppler, xineLib, ghostscript, makeWrapper }:

stdenv.mkDerivation rec {
  name = "eaglemode-${version}";
  version = "0.94.0";

  src = fetchurl {
    url = "mirror://sourceforge/eaglemode/${name}.tar.bz2";
    sha256 = "1sr3bd9y9j2svqvdwhrak29yy9cxf92w9vq2cim7a8hzwi9qfy9k";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ perl libX11 libXinerama libjpeg libpng libtiff
    librsvg glib gtk2 libXxf86vm libXext poppler xineLib ghostscript makeWrapper ];

  # The program tries to dlopen Xxf86vm, Xext and Xinerama, so we use the
  # trick on NIX_LDFLAGS and dontPatchELF to make it find them.
  # I use 'yes y' to skip a build error linking with xineLib,
  # because xine stopped exporting "_x_vo_new_port"
  #  https://sourceforge.net/projects/eaglemode/forums/forum/808824/topic/5115261
  buildPhase = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lXxf86vm -lXext -lXinerama"
    perl make.pl build
  '';

  dontPatchELF = true;
  # eaglemode expects doc to be in the root directory
  forceShare = [ "man" "info" ];

  installPhase = ''
    perl make.pl install dir=$out
    wrapProgram $out/bin/eaglemode --set EM_DIR "$out" --prefix LD_LIBRARY_PATH : "$out/lib" --prefix PATH : "${ghostscript}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = http://eaglemode.sourceforge.net;
    description = "Zoomable User Interface";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
