{ stdenv, fetchurl, makeDesktopItem
, ghostscript, atk, gtk2, glib, fontconfig, freetype
, libgnomecanvas, libgnomeprint, libgnomeprintui
, pango, libX11, xproto, zlib, poppler
, autoconf, automake, libtool, pkgconfig}:

let
  isGdkQuartzBackend = (gtk2.gdktarget == "quartz");
in

stdenv.mkDerivation rec {
  version = "0.4.8";
  name = "xournal-" + version;
  src = fetchurl {
    url = "mirror://sourceforge/xournal/${name}.tar.gz";
    sha256 = "0c7gjcqhygiyp0ypaipdaxgkbivg6q45vhsj8v5jsi9nh6iqff13";
  };

  buildInputs = [
    ghostscript atk gtk2 glib fontconfig freetype
    libgnomecanvas
    pango libX11 xproto zlib poppler
  ] ++ stdenv.lib.optionals (!stdenv.isDarwin) [
    libgnomeprint libgnomeprintui
  ];

  nativeBuildInputs = [ autoconf automake libtool pkgconfig ];

  patches = stdenv.lib.optionals isGdkQuartzBackend [
    ./gdk-quartz-backend.patch
  ];

  NIX_LDFLAGS = [ "-lz" ]
    ++ stdenv.lib.optionals (!isGdkQuartzBackend) [ "-lX11" ];

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
