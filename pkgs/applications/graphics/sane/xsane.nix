{ stdenv, fetchurl, saneBackends, saneFrontends, libX11, gtk, pkgconfig, libpng
, libusb ? null
, gimpSupport ? false, gimp_2_8 ? null
}:

assert gimpSupport -> gimp_2_8 != null;

stdenv.mkDerivation rec {
  name = "xsane-0.998";

  src = fetchurl {
    url = "http://www.xsane.org/download/${name}.tar.gz";
    sha256 = "0vn2cj85ijgp2v2j2h9xpqmg2jwlbxmwyb88kxhjjakqay02ybm3";
  };

  preConfigure = ''
    sed -e '/SANE_CAP_ALWAYS_SETTABLE/d' -i src/xsane-back-gtk.c
  '';

  buildInputs = [libpng saneBackends saneFrontends libX11 gtk pkgconfig ]
    ++ (if libusb != null then [libusb] else [])
    ++ stdenv.lib.optional gimpSupport gimp_2_8;

  meta = {
    homepage = http://www.sane-project.org/;
    description = "Graphical scanning frontend for sane";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric simons];
    platforms = with stdenv.lib.platforms; linux;
  };
}
