{ stdenv, fetchurl, gtk, jackaudio, lilv, lv2, pkgconfig, python
, serd, sord , sratom, suil }:

stdenv.mkDerivation  rec {
  name = "jalv-${version}";
  version = "1.4.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "1hq968fhiz86428krqhjl3vlw71bigc9bsfcv97zgvsjh0fh6qa0";
  };

  buildInputs = [
    gtk jackaudio lilv lv2 pkgconfig python serd sord sratom suil
  ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    description = "A simple but fully featured LV2 host for Jack";
    homepage = http://drobilla.net/software/jalv;
    license = licenses.isc;
    maintainers = [ maintainers.goibhniu ];
  };
}
