{ lib
, stdenv
, fetchurl
, sane-backends
, sane-frontends
, libX11
, gtk2
, pkg-config
, libpng
, libusb-compat-0_1
, gimpSupport ? false
, gimp
}:

stdenv.mkDerivation rec {
  pname = "xsane";
  version = "0.999";

  src = fetchurl {
    url = "http://www.xsane.org/download/xsane-${version}.tar.gz";
    sha256 = "0jrb918sfb9jw3vmrz0z7np4q55hgsqqffpixs0ir5nwcwzd50jp";
  };

  preConfigure = ''
    sed -e '/SANE_CAP_ALWAYS_SETTABLE/d' -i src/xsane-back-gtk.c
    chmod a+rX -R .
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpng libusb-compat-0_1 sane-backends sane-frontends libX11 gtk2 ]
    ++ lib.optional gimpSupport gimp;

  meta = with lib; {
    homepage = "http://www.sane-project.org/";
    description = "Graphical scanning frontend for sane";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
