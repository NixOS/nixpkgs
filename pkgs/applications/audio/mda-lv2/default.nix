{ stdenv, fetchurl, fftwSinglePrec, lv2, pkgconfig, wafHook }:

stdenv.mkDerivation rec {
  pname = "mda-lv2";
  version = "1.2.4";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "1a3cv6w5xby9yn11j695rbh3c4ih7rxfxmkca9s1324ljphh06m8";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ fftwSinglePrec lv2 ];

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/mda-lv2/;
    description = "An LV2 port of the MDA plugins by Paul Kellett";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
