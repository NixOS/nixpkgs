{ stdenv, fetchurl, perl, perlPackages, makeWrapper, imagemagick, gdk_pixbuf, librsvg }:

let
  perlModules = with perlPackages;
    [ Gnome2 Gnome2Canvas Gtk2 Glib Pango Gnome2VFS Gnome2Wnck Gtk2ImageView
      Gtk2Unique FileWhich FileCopyRecursive XMLSimple NetDBus XMLTwig
      XMLParser HTTPMessage ProcSimple SortNaturally LocaleGettext
      ProcProcessTable URI ImageExifTool Gtk2AppIndicator LWPUserAgent JSON
      PerlMagick WWWMechanize HTTPDate HTMLForm HTMLParser HTMLTagset JSONXS
      CommonSense HTTPCookies NetOAuth PathClass GooCanvas X11Protocol Cairo
    ];
in
stdenv.mkDerivation rec {
  name = "shutter-0.93.1";

  src = fetchurl {
    url = "http://shutter-project.org/wp-content/uploads/releases/tars/${name}.tar.gz";
    sha256 = "09cn3scwy98wqxkrjhnmxhpfnnynlbb41856yn5m3zwzqrxiyvak";
  };

  buildInputs = [ perl makeWrapper gdk_pixbuf librsvg ] ++ perlModules;

  installPhase = ''
    mkdir -p "$out"
    cp -a . "$out"
    (cd "$out" && mv CHANGES README COPYING "$out/share/doc/shutter")

    wrapProgram $out/bin/shutter \
      --set PERL5LIB "${stdenv.lib.makePerlPath perlModules}" \
      --prefix PATH : "${imagemagick}/bin" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  meta = with stdenv.lib; {
    description = "Screenshot and annotation tool";
    homepage = http://shutter-project.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
