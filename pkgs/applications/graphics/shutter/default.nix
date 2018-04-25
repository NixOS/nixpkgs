{ stdenv, fetchurl, fetchpatch, perl, perlPackages, makeWrapper, imagemagick, gdk_pixbuf, librsvg }:

let
  perlModules = with perlPackages;
    [ Gnome2 Gnome2Canvas Gtk2 Glib Pango Gnome2VFS Gnome2Wnck Gtk2ImageView
      Gtk2Unique FileWhich FileCopyRecursive XMLSimple NetDBus XMLTwig
      XMLParser HTTPMessage ProcSimple SortNaturally LocaleGettext
      ProcProcessTable URI ImageExifTool Gtk2AppIndicator LWPUserAgent JSON
      PerlMagick WWWMechanize HTTPDate HTMLForm HTMLParser HTMLTagset JSONXS
      CommonSense HTTPCookies NetOAuth PathClass GooCanvas X11Protocol Cairo
      EncodeLocale TryTiny TypesSerialiser LWPMediaTypes
    ];
in
stdenv.mkDerivation rec {
  name = "shutter-0.94";

  src = fetchurl {
    url = "https://launchpad.net/shutter/0.9x/0.94/+download/shutter-0.94.tar.gz";
    sha256 = "943152cdf9e1b2096d38e3da9622d8bf97956a08eda747c3e7fcc564a3f0f40d";
  };

  buildInputs = [ perl makeWrapper gdk_pixbuf librsvg ] ++ perlModules;

  installPhase = ''
    mkdir -p "$out"
    cp -a . "$out"
    (cd "$out" && mv CHANGES README COPYING "$out/share/doc/shutter")

    wrapProgram $out/bin/shutter \
      --set PERL5LIB "${stdenv.lib.makePerlPath perlModules}" \
      --prefix PATH : "${imagemagick.out}/bin" \
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
