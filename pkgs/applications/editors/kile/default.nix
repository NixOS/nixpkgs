{stdenv, fetchurl, kdelibs, cmake, gettext }:

stdenv.mkDerivation rec {
  name = "kile-2.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/kile/${name}.tar.bz2";
    sha256 = "0nx5fmjrxrndnzvknxnybd8qh15jzfxzbny2rljq3amjw02y9lc2";
  };

  buildNativeInputs = [ cmake gettext ];
  buildInputs = [ kdelibs ];

  meta = {
    description = "An integrated LaTeX editor for KDE";
    homepage = http://kile.sourceforge.net;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    license = stdenv.lib.licenses.gpl2Plus;
    inherit (kdelibs.meta) platforms;
  };
}
