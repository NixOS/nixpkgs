{ fetchurl, stdenv, pkgconfig, gtk, gettext, bzip2, zlib
, libjpeg, libtiff, cfitsio, exiv2, lcms, gtkimageview }:

stdenv.mkDerivation rec {
  name = "ufraw-0.16";

  src = fetchurl {
    url = "mirror://sourceforge/ufraw/${name}.tar.gz";
    sha256 = "0d3hd04msdk6l0nv1n8zs3ybipy3jikli57d9q41pb7v0hnl6hzd";
  };

  patches = [ ./mkinstalldirs.patch ];
  preConfigure = "chmod +x mkinstalldirs";

  buildInputs =
    [ pkgconfig gtk gtkimageview gettext bzip2 zlib
      libjpeg libtiff cfitsio exiv2 lcms
    ];

  meta = {
    homepage = http://ufraw.sourceforge.net/;

    description = "UFRaw, a utility to read and manipulate raw images from digital cameras";

    longDescription =
      '' The Unidentified Flying Raw (UFRaw) is a utility to read and
         manipulate raw images from digital cameras.  It can be used on its
         own or as a Gimp plug-in.  It reads raw images using Dave Coffin's
         raw conversion utility - DCRaw.  UFRaw supports color management
         workflow based on Little CMS, allowing the user to apply ICC color
         profiles.  For Nikon users UFRaw has the advantage that it can read
         the camera's tone curves.
      '';

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
