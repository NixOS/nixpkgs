{ stdenv, fetchurl, gtk2, libjack2, lilv, lv2, pkgconfig, python
, serd, sord , sratom, suil, wafHook }:

stdenv.mkDerivation  rec {
  pname = "jalv";
  version = "1.6.2";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "13al2hb9s3m7jgbg051x704bmzmcg4wb56cfh8z588kiyh0mxpaa";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [
    gtk2 libjack2 lilv lv2 python serd sord sratom suil
  ];

  meta = with stdenv.lib; {
    description = "A simple but fully featured LV2 host for Jack";
    homepage = http://drobilla.net/software/jalv;
    license = licenses.isc;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
