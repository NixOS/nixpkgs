{ stdenv, fetchurl, pkgconfig, autoconf, automake, gettext, intltool
, gtk3, lcms2, exiv2, libchamplain, clutter-gtk, ffmpegthumbnailer, fbida
}:

stdenv.mkDerivation rec {
  name = "geeqie-${version}";
  version = "1.4";

  src = fetchurl {
    url = "http://geeqie.org/${name}.tar.xz";
    sha256 = "0ciygvcxb78pqg59r6p061mkbpvkgv2rv3r79j3kgv3kalb3ln2w";
  };

  # Do not build the changelog as this requires markdown.
  patches = [ ./geeqie-no-changelog.patch ];

  preConfigure = "./autogen.sh";

  nativeBuildInputs = [ pkgconfig autoconf automake gettext intltool ];
  buildInputs = [
    gtk3 lcms2 exiv2 libchamplain clutter-gtk ffmpegthumbnailer fbida
  ];

  postInstall = ''
    # Allow geeqie to find exiv2 and exiftran, necessary to
    # losslessly rotate JPEG images.
    sed -i $out/lib/geeqie/geeqie-rotate \
        -e '1 a export PATH=${stdenv.lib.makeBinPath [ exiv2 fbida ]}:$PATH'
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Lightweight GTK+ based image viewer";

    longDescription =
      ''
        Geeqie is a lightweight GTK+ based image viewer for Unix like
        operating systems.  It features: EXIF, IPTC and XMP metadata
        browsing and editing interoperability; easy integration with other
        software; geeqie works on files and directories, there is no need to
        import images; fast preview for many raw image formats; tools for
        image comparison, sorting and managing photo collection.  Geeqie was
        initially based on GQview.
      '';

    license = licenses.gpl2Plus;

    homepage = http://geeqie.sourceforge.net;

    maintainers = with maintainers; [ jfrankenau pSub ];
    platforms = platforms.gnu;
  };
}
