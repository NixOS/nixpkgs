{ stdenv, fetchgit, pkgconfig, autoconf, automake, gtk, libpng, exiv2, lcms
, intltool, gettext, libchamplain, fbida }:

stdenv.mkDerivation rec {
  name = "geeqie-${version}";
  version = "1.2";

  src = fetchgit {
    url = "git://gitorious.org/geeqie/geeqie.git";
    rev = "refs/tags/v${version}";
    sha256 = "1h9w0jrcqcp5jjgmks5pvpppnfxhcd1s3vqlyb3qyil2wfk8n8wp";
  };

  preConfigure = "./autogen.sh";

  configureFlags = [ "--enable-gps" ];

  buildInputs =
    [ pkgconfig autoconf automake gtk libpng exiv2 lcms intltool gettext
      libchamplain
    ];

  postInstall =
    ''
      # Allow geeqie to find exiv2 and exiftran, necessary to
      # losslessly rotate JPEG images.
      sed -i $out/lib/geeqie/geeqie-rotate \
          -e '1 a export PATH=${exiv2}/bin:${fbida}/bin:$PATH'
    '';

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

    maintainers = with maintainers; [ pSub ];
    platforms = platforms.gnu;
  };
}
