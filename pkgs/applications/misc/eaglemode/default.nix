{ lib, stdenv, fetchurl, perl, libX11, libXinerama, libjpeg, libpng, libtiff, pkg-config,
librsvg, glib, gtk2, libXext, libXxf86vm, poppler, xine-lib, ghostscript, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "eaglemode";
  version = "0.94.2";

  src = fetchurl {
    url = "mirror://sourceforge/eaglemode/${pname}-${version}.tar.bz2";
    sha256 = "10zxih7gmyhq0az1mnsw2x563l4bbwcns794s4png8rf4d6hjszm";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ perl libX11 libXinerama libjpeg libpng libtiff
    librsvg glib gtk2 libXxf86vm libXext poppler xine-lib ghostscript ];

  # The program tries to dlopen Xxf86vm, Xext and Xinerama, so we use the
  # trick on NIX_LDFLAGS and dontPatchELF to make it find them.
  # I use 'yes y' to skip a build error linking with xine-lib,
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

  meta = with lib; {
    homepage = "http://eaglemode.sourceforge.net";
    description = "Zoomable User Interface";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
