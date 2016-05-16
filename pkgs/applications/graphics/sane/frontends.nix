{ stdenv, fetchurl, sane-backends, libX11, gtk, pkgconfig, libusb ? null}:

stdenv.mkDerivation rec {
  name = "sane-frontends-1.0.14";

  src = fetchurl {
    url = "ftp://ftp.sane-project.org/pub/sane/sane-frontends-1.0.14/${name}.tar.gz";
    md5 = "c63bf7b0bb5f530cf3c08715db721cd3";
  };

  preConfigure = ''
    sed -e '/SANE_CAP_ALWAYS_SETTABLE/d' -i src/gtkglue.c
  '';

  buildInputs = [sane-backends libX11 gtk pkgconfig] ++
	(if libusb != null then [libusb] else []);

  meta = {
    homepage = "http://www.sane-project.org/";
    description = "Scanner Access Now Easy";
    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ stdenv.lib.maintainers.peti ];
    platforms = stdenv.lib.platforms.linux;
  };
}
