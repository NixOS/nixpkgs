{ stdenv, fetchurl, libosip }:

stdenv.mkDerivation rec {
  name = "siproxd-0.8.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/siproxd/${name}.tar.gz";
    sha256 = "1bcxl0h5nc28m8lcdhpbl5yc93w98xm53mfzrf04knsvmx7z0bfz";
  };

  patches = [ ./cheaders.patch ];

  buildInputs = [ libosip ];

  meta = {
    homepage = http://siproxd.sourceforge.net/;
    description = "A masquerading SIP Proxy Server";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
