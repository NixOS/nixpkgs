{ stdenv, fetchurl,
  GConf, cairo, curl, dbus_glib, exiv2, gnome_keyring, gphoto2, gtk,
  intltool, lcms, lensfun, libexif, libglade, libgphoto2, libjpeg,
  libpng, libraw1394, librsvg, libtiff, openexr, pkgconfig, sqlite, }:

stdenv.mkDerivation rec {
  version = "0.7.1";
  name = "darktable-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/darktable/darktable-${version}.tar.gz";
    sha256 = "080gvf5gp3rb0vlsvdgnzrzky9dfpqw5cwnj6z1k8lvryd9fzahm";
  };

  patches = [ ./exif.patch ];

  buildInputs = [ GConf cairo curl dbus_glib exiv2 gnome_keyring gtk
                        intltool lcms lensfun libexif libglade
                        libgphoto2 libjpeg libpng libraw1394 librsvg
                        libtiff openexr pkgconfig sqlite ];

  meta = {
    description = "a virtual lighttable and darkroom for photographers";
    homepage = http://darktable.sourceforge.net;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
