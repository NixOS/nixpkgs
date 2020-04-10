{ stdenv, fetchurl, pkgconfig, autoconf, automake, gettext, intltool
, gtk3, lcms2, exiv2, libchamplain, clutter-gtk, ffmpegthumbnailer, fbida
, wrapGAppsHook, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "geeqie";
  version = "1.4";

  src = fetchurl {
    url = "http://geeqie.org/${pname}-${version}.tar.xz";
    sha256 = "0ciygvcxb78pqg59r6p061mkbpvkgv2rv3r79j3kgv3kalb3ln2w";
  };

  patches = [
    # Do not build the changelog as this requires markdown.
    (fetchpatch {
      name = "geeqie-1.4-goodbye-changelog.patch";
      url = "https://src.fedoraproject.org/rpms/geeqie/raw/132fb04a1a5e74ddb333d2474f7edb9a39dc8d27/f/geeqie-1.4-goodbye-changelog.patch";
      sha256 = "00a35dds44kjjdqsbbfk0x9y82jspvsbpm2makcm1ivzlhjjgszn";
    })
    # Fixes build with exiv2 0.27.1
    (fetchpatch {
      name = "geeqie-exiv2-0.27.patch";
      url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/geeqie-exiv2-0.27.patch?h=packages/geeqie&id=dee28a8b3e9039b9cd6927b5a93ef2a07cd8271d";
      sha256 = "05skpbyp8pcq92psgijyccc8liwfy2cpwprw6m186pf454yb5y9p";
    })
  ];

  preConfigure = "./autogen.sh";

  nativeBuildInputs = [ pkgconfig autoconf automake gettext intltool
    wrapGAppsHook
  ];
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
    description = "Lightweight GTK based image viewer";

    longDescription =
      ''
        Geeqie is a lightweight GTK based image viewer for Unix like
        operating systems.  It features: EXIF, IPTC and XMP metadata
        browsing and editing interoperability; easy integration with other
        software; geeqie works on files and directories, there is no need to
        import images; fast preview for many raw image formats; tools for
        image comparison, sorting and managing photo collection.  Geeqie was
        initially based on GQview.
      '';

    license = licenses.gpl2Plus;

    homepage = "http://geeqie.sourceforge.net";

    maintainers = with maintainers; [ jfrankenau pSub ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}
