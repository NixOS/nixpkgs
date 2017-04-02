{ stdenv, fetchurl, lv2, pkgconfig, python2 }:

stdenv.mkDerivation rec {
  name = "fomp-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "1hh2xhknanqn3iwp12ihl6bf8p7bqxryms9qk7mh21lixl42b8k5";
  };

  buildInputs = [ lv2  pkgconfig python2 ];

  installPhase = ''
    python waf configure --prefix=$out
    python waf
    python waf install
  '';

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/fomp/;
    description = "An LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
