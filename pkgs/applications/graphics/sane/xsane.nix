{ stdenv, fetchurl, sane-backends, sane-frontends, libX11, gtk, pkgconfig, libpng
, libusb ? null
, gimpSupport ? false, gimp_2_8 ? null
}:

assert gimpSupport -> gimp_2_8 != null;

stdenv.mkDerivation rec {
  name = "xsane-0.999";

  src = fetchurl {
    url = "http://www.xsane.org/download/${name}.tar.gz";
    sha256 = "0jrb918sfb9jw3vmrz0z7np4q55hgsqqffpixs0ir5nwcwzd50jp";
  };

  preConfigure = ''
    sed -e '/SANE_CAP_ALWAYS_SETTABLE/d' -i src/xsane-back-gtk.c
    chmod a+rX -R .
  '';

  buildInputs = [libpng sane-backends sane-frontends libX11 gtk pkgconfig ]
    ++ (if libusb != null then [libusb] else [])
    ++ stdenv.lib.optional gimpSupport gimp_2_8;

  meta = {
    homepage = http://www.sane-project.org/;
    description = "Graphical scanning frontend for sane";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric peti];
    platforms = with stdenv.lib.platforms; linux;
  };
}
