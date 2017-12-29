{ stdenv, fetchurl, sane-backends, libX11, gtk2, pkgconfig, libusb ? null}:

stdenv.mkDerivation rec {
  name = "sane-frontends-1.0.14";

  src = fetchurl {
    url = "https://alioth.debian.org/frs/download.php/file/1140/${name}.tar.gz";
    sha256 = "1ad4zr7rcxpda8yzvfkq1rfjgx9nl6lan5a628wvpdbh3fn9v0z7";
  };

  preConfigure = ''
    sed -e '/SANE_CAP_ALWAYS_SETTABLE/d' -i src/gtkglue.c
  '';

  buildInputs = [sane-backends libX11 gtk2 pkgconfig] ++
	(if libusb != null then [libusb] else []);

  meta = {
    homepage = http://www.sane-project.org/;
    description = "Scanner Access Now Easy";
    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ stdenv.lib.maintainers.peti ];
    platforms = stdenv.lib.platforms.linux;
  };
}
