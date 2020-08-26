{ stdenv, fetchurl, sane-backends, sane-frontends, libX11, gtk2, pkgconfig, libpng
, libusb-compat-0_1 ? null
, gimpSupport ? false, gimp ? null
}:

assert gimpSupport -> gimp != null;

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

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [libpng sane-backends sane-frontends libX11 gtk2 ]
    ++ (if libusb-compat-0_1 != null then [libusb-compat-0_1] else [])
    ++ stdenv.lib.optional gimpSupport gimp;

  meta = {
    homepage = "http://www.sane-project.org/";
    description = "Graphical scanning frontend for sane";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [peti];
    platforms = with stdenv.lib.platforms; linux;
  };
}
