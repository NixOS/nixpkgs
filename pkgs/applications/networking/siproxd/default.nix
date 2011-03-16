{ stdenv, fetchurl, libosip }:

stdenv.mkDerivation {
  name = "siproxd-0.8.0";
  
  src = fetchurl {
    url = mirror://sourceforge/siproxd/siproxd-0.8.0.tar.gz;
    sha256 = "0hl51z33cf68ki707jkrrjjc3a5vpaf49gbrsz3g4rfxypdhc0qs";
  };

  buildInputs = [ libosip ];

  meta = {
    homepage = http://siproxd.sourceforge.net/;
    description = "A masquerading SIP Proxy Server";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
