{ stdenv, fetchurl, fetchpatch, autoreconfHook, pkgconfig, intltool, babl, gegl, gtk2, glib, gdk_pixbuf, isocodes
, pango, cairo, freetype, fontconfig, lcms, libpng, libjpeg, poppler, poppler_data, libtiff
, libmng, librsvg, libwmf, zlib, libzip, ghostscript, aalib, shared-mime-info
, python2Packages, libexif, gettext, xorg, glib-networking, libmypaint, gexiv2
, harfbuzz, mypaint-brushes, libwebp, libgudev, openexr
, AppKit, Cocoa, gtk-mac-integration }:

let
  inherit (python2Packages) pygtk wrapPython python;
in stdenv.mkDerivation rec {
  name = "gimp-${version}";
  version = "2.10.0";

  src = fetchurl {
    url = "http://download.gimp.org/pub/gimp/v${stdenv.lib.versions.majorMinor version}/${name}.tar.bz2";
    sha256 = "1qkxaigbfkx26xym5nzrgfrmn97cbnhn63v1saaha2nbi3xrdk3z";
  };

  patches = [
    # fix rpath of python library https://bugzilla.gnome.org/show_bug.cgi?id=795620
    (fetchurl {
      url = https://bugzilla.gnome.org/attachment.cgi?id=371482;
      sha256 = "18bysndh61pvlv255xapdrfpsl5ivm51wp1w7xgk9vky9z2y3llc";
    })

    # fix absolute paths stored in configuration
    (fetchpatch {
      url = https://git.gnome.org/browse/gimp/patch/?id=0fce8fdb3c056acead8322c976a96fb6fba793b6;
      sha256 = "09845i3bdpdbf13razr04ksvwydxcvzhjwlb4dfgdv5q203g2ris";
    })
    (fetchpatch {
      url = https://git.gnome.org/browse/gimp/patch/?id=f6b586237cb8c912c1503f8e6086edd17f07d4df;
      sha256 = "0s68885ip2wgjvsl5vqi2f1xhxdjpzqprifzgdl1vnv6gqmfy3bh";
    })

    # fix pc file (needed e.g. for building plug-ins)
    (fetchpatch {
      url = https://git.gnome.org/browse/gimp/patch/?id=7e19906827d301eb70275dba089849a632a0eabe;
      sha256 = "0cbjfbwvzg2hqihg3rpsga405v7z2qahj22dfqn2jrb2gbhrjcp1";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig intltool gettext wrapPython ];
  propagatedBuildInputs = [ gegl ]; # needed by gimp-2.0.pc
  buildInputs = [
    babl gegl gtk2 glib gdk_pixbuf pango cairo gexiv2 harfbuzz isocodes
    freetype fontconfig lcms libpng libjpeg poppler poppler_data libtiff openexr
    libmng librsvg libwmf zlib libzip ghostscript aalib shared-mime-info libwebp
    python pygtk libexif xorg.libXpm glib-networking libmypaint mypaint-brushes
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit Cocoa gtk-mac-integration ]
    ++ stdenv.lib.optionals stdenv.isLinux [ libgudev ];

  pythonPath = [ pygtk ];

  # Check if librsvg was built with --disable-pixbuf-loader.
  PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${librsvg}/${gdk_pixbuf.moduleDir}";

  preConfigure = ''
    # The check runs before glib-networking is registered
    export GIO_EXTRA_MODULES="${glib-networking}/lib/gio/modules:$GIO_EXTRA_MODULES"
  '';

  postFixup = ''
    wrapPythonProgramsIn $out/lib/gimp/${passthru.majorVersion}/plug-ins/
    wrapProgram $out/bin/gimp-${stdenv.lib.versions.majorMinor version} \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  passthru = rec {
    # The declarations for `gimp-with-plugins` wrapper,
    # used for determining plug-in installation paths
    majorVersion = "${stdenv.lib.versions.major version}.0";
    targetPluginDir = "lib/gimp/${majorVersion}/plug-ins";
    targetScriptDir = "lib/gimp/${majorVersion}/scripts";

    # probably its a good idea to use the same gtk in plugins ?
    gtk = gtk2;
  };

  configureFlags = [
    "--without-webkit" # old version is required
  ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The GNU Image Manipulation Program";
    homepage = https://www.gimp.org/;
    maintainers = with maintainers; [ jtojnar ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
