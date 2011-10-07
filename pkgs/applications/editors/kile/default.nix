{stdenv, fetchurl, kdelibs, cmake, gettext }:

stdenv.mkDerivation rec {
  name = "kile-2.1";

  src = fetchurl {
    url = "mirror://sourceforge/kile/${name}.tar.bz2";
    sha256 = "0ag6ya0625w34hpk0bpkjyi0ydw699zbkf86vwc19mh9cb0n0aic";
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
