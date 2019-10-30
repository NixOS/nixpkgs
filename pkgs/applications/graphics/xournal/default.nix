{ stdenv, fetchurl, makeDesktopItem
, ghostscript, atk, gtk2, glib, fontconfig, freetype
, libgnomecanvas, libgnomeprint, libgnomeprintui
, pango, libX11, xorgproto, zlib, poppler
, autoconf, automake, libtool, pkgconfig}:

let
  isGdkQuartzBackend = (gtk2.gdktarget == "quartz");
in

stdenv.mkDerivation rec {
  version = "0.4.8.2016";
  name = "xournal-" + version;
  src = fetchurl {
    url = "mirror://sourceforge/xournal/${name}.tar.gz";
    sha256 = "09i88v3wacmx7f96dmq0l3afpyv95lh6jrx16xzm0jd1szdrhn5j";
  };

  buildInputs = [
    ghostscript atk gtk2 glib fontconfig freetype
    libgnomecanvas
    pango libX11 xorgproto zlib poppler
  ] ++ stdenv.lib.optionals (!stdenv.isDarwin) [
    libgnomeprint libgnomeprintui
  ];

  nativeBuildInputs = [ autoconf automake libtool pkgconfig ];

  NIX_LDFLAGS = "-lz"
    + stdenv.lib.optionalString (!isGdkQuartzBackend) " -lX11";

  desktopItem = makeDesktopItem {
    name = name;
    exec = "xournal";
    icon = "xournal";
    desktopName = "Xournal";
    comment = meta.description;
    categories = "Office;Graphics;";
    mimeType = "application/pdf;application/x-xoj";
    genericName = "PDF Editor";
  };

  postInstall=''
      mkdir --parents $out/share/mime/packages
      cat << EOF > $out/share/mime/packages/xournal.xml
      <mime-info xmlns='http://www.freedesktop.org/standards/shared-mime-info'>
         <mime-type type="application/x-xoj">
          <comment>Xournal Document</comment>
          <glob pattern="*.xoj"/>
         </mime-type>
      </mime-info>
      EOF
      cp --recursive ${desktopItem}/share/applications $out/share
      mkdir --parents $out/share/icons
      cp $out/share/xournal/pixmaps/xournal.png $out/share/icons
  '';

  meta = with stdenv.lib; {
    homepage = http://xournal.sourceforge.net/;
    description = "Note-taking application (supposes stylus)";
    maintainers = [ maintainers.guibert ];
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
  };
}
