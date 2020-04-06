{ stdenv, fetchurl, lv2, pkgconfig, python2, wafHook }:

stdenv.mkDerivation rec {
  pname = "fomp";
  version = "1.2.0";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "01ld6yjrqrki6zwac8lmwmqkr5rv0sdham4pfbfkjwck4hi1gqqw";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ lv2 python2 ];

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/fomp/;
    description = "An LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
