{ stdenv, fetchurl, pkgconfig, gtk, libpng, exiv2, lcms
, intltool, gettext, libchamplain_0_6, fbida }:

stdenv.mkDerivation rec {
  name = "geeqie-1.1";

  src = fetchurl {
    url = "mirror://sourceforge/geeqie/${name}.tar.gz";
    sha256 = "1kzy39z9505xkayyx7rjj2wda76xy3ch1s5z35zn8yli54ffhi2m";
  };

  preConfigure =
    # XXX: Trick to have Geeqie use the version we have.
    '' sed -i "configure" \
           -e 's/champlain-0.4/champlain-0.6/g ;
               s/champlain-gtk-0.4/champlain-gtk-0.6/g'
    '';

  configureFlags = [ "--enable-gps" ];

  buildInputs =
    [ pkgconfig gtk libpng exiv2 lcms intltool gettext
      libchamplain_0_6
    ];

  postInstall =
    ''
      # Allow geeqie to find exiv2 and exiftran, necessary to
      # losslessly rotate JPEG images.
      sed -i $out/lib/geeqie/geeqie-rotate \
          -e '1 a export PATH=${exiv2}/bin:${fbida}/bin:$PATH'
    '';

  meta = {
    description = "Geeqie, a lightweight GTK+ based image viewer";

    longDescription =
      '' Geeqie is a lightweight GTK+ based image viewer for Unix like
         operating systems.  It features: EXIF, IPTC and XMP metadata
         browsing and editing interoperability; easy integration with other
         software; geeqie works on files and directories, there is no need to
         import images; fast preview for many raw image formats; tools for
         image comparison, sorting and managing photo collection.  Geeqie was
         initially based on GQview.
      '';

    license = "GPLv2+";

    homepage = http://geeqie.sourceforge.net;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
