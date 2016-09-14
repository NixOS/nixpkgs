{ fetchurl, stdenv, pkgconfig, gtk2, gettext, bzip2, zlib
, libjpeg, libtiff, cfitsio, exiv2, lcms2, gtkimageview, lensfun }:

stdenv.mkDerivation rec {
  name = "ufraw-0.22";

  src = fetchurl {
    # XXX: These guys appear to mutate uploaded tarballs!
    url = "mirror://sourceforge/ufraw/${name}.tar.gz";
    sha256 = "0pm216pg0vr44gwz9vcvq3fsf8r5iayljhf5nis2mnw7wn6d5azp";
  };

  buildInputs =
    [ pkgconfig gtk2 gtkimageview gettext bzip2 zlib
      libjpeg libtiff cfitsio exiv2 lcms2 lensfun
    ];

  meta = {
    homepage = http://ufraw.sourceforge.net/;

    description = "Utility to read and manipulate raw images from digital cameras";

    longDescription =
      '' The Unidentified Flying Raw (UFRaw) is a utility to read and
         manipulate raw images from digital cameras.  It can be used on its
         own or as a Gimp plug-in.  It reads raw images using Dave Coffin's
         raw conversion utility - DCRaw.  UFRaw supports color management
         workflow based on Little CMS, allowing the user to apply ICC color
         profiles.  For Nikon users UFRaw has the advantage that it can read
         the camera's tone curves.
      '';

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.gnu;  # needs GTK+
  };
}
