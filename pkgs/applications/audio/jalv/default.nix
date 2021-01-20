{ lib, stdenv, fetchurl, gtk2, libjack2, lilv, lv2, pkg-config, python
, serd, sord , sratom, suil, wafHook }:

stdenv.mkDerivation  rec {
  pname = "jalv";
  version = "1.6.4";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "1wwfn7yzbs37s2rdlfjgks63svd5g14yyzd2gdl7h0z12qncwsy2";
  };

  nativeBuildInputs = [ pkg-config wafHook ];
  buildInputs = [
    gtk2 libjack2 lilv lv2 python serd sord sratom suil
  ];

  meta = with lib; {
    description = "A simple but fully featured LV2 host for Jack";
    homepage = "http://drobilla.net/software/jalv";
    license = licenses.isc;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
