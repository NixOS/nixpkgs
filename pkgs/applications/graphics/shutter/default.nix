{ stdenv, fetchurl, perlPackages, makeWrapper, imagemagick, gdk_pixbuf, librsvg
, hicolor-icon-theme, procps
}:

let
  perlModules = with perlPackages;
    [ Gnome2 Gnome2Canvas Gtk2 Glib Pango Gnome2VFS Gnome2Wnck Gtk2ImageView
      Gtk2Unique FileBaseDir FileWhich FileCopyRecursive XMLSimple NetDBus XMLTwig
      XMLParser HTTPMessage ProcSimple SortNaturally LocaleGettext
      ProcProcessTable URI ImageExifTool Gtk2AppIndicator LWP JSON
      PerlMagick WWWMechanize HTTPDate HTMLForm HTMLParser HTMLTagset JSONMaybeXS
      commonsense HTTPCookies NetOAuth PathClass GooCanvas X11Protocol Cairo
      EncodeLocale TryTiny TypesSerialiser LWPMediaTypes
    ];
in
stdenv.mkDerivation rec {
  name = "shutter-0.94.2";

  src = fetchurl {
    url = "https://launchpad.net/shutter/0.9x/0.94.2/+download/shutter-0.94.2.tar.gz";
    sha256 = "0mas7npm935j4rhqqjn226822s9sa4bsxrkp0b5fjj3z096k6vw0";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perlPackages.perl procps gdk_pixbuf librsvg ] ++ perlModules;

  installPhase = ''
    mkdir -p "$out"
    cp -a . "$out"
    (cd "$out" && mv CHANGES README COPYING "$out/share/doc/shutter")

    wrapProgram $out/bin/shutter \
      --set PERL5LIB "${perlPackages.makePerlPath perlModules}" \
      --prefix PATH : "${imagemagick.out}/bin" \
      --suffix XDG_DATA_DIRS : "${hicolor-icon-theme}/share" \
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
