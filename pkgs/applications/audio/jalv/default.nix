{ stdenv, fetchurl, gtk2, libjack2, lilv, lv2, pkgconfig, python
, serd, sord , sratom, suil }:

stdenv.mkDerivation  rec {
  name = "jalv-${version}";
  version = "1.6.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "1x2wpzzx2cgvz3dgdcgsj8dr0w3zsasy62mvl199bsdj5fbjaili";
  };

  buildInputs = [
    gtk2 libjack2 lilv lv2 pkgconfig python serd sord sratom suil
  ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    description = "A simple but fully featured LV2 host for Jack";
    homepage = http://drobilla.net/software/jalv;
    license = licenses.isc;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
