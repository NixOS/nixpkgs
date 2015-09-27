{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig
, shared_mime_info, kdelibs
}:

stdenv.mkDerivation rec {
  name = "kile-2.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/kile/${name}.tar.bz2";
    sha256 = "18nfi37s46v9xav7vyki3phasddgcy4m7nywzxis198vr97yqqx0";
  };

  nativeBuildInputs = [
    automoc4 cmake gettext perl pkgconfig shared_mime_info
  ];
  buildInputs = [ kdelibs ];

  # for KDE 4.7 the nl translations fail since kile-2.1.2
  preConfigure = "rm -r translations/nl";

  meta = {
    description = "An integrated LaTeX editor for KDE";
    homepage = http://kile.sourceforge.net;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    license = stdenv.lib.licenses.gpl2Plus;
    inherit (kdelibs.meta) platforms;
  };
}
