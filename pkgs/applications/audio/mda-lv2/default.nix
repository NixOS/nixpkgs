{ stdenv, fetchurl, fftwSinglePrec, lv2, pkgconfig, python, wafHook }:

stdenv.mkDerivation rec {
  name = "mda-lv2-${version}";
  version = "1.2.2";

  src = fetchurl {
    url = "https://download.drobilla.net/${name}.tar.bz2";
    sha256 = "0hh40c5d2m0k5gb3vw031l6lqn59dg804an3mkmhkc7qv4gc6xm4";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ fftwSinglePrec lv2 python ];

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/mda-lv2/;
    description = "An LV2 port of the MDA plugins by Paul Kellett";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
