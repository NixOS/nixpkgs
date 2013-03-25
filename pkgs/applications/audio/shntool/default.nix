{ stdenv, fetchurl, flac }:

stdenv.mkDerivation rec {
  version = "3.0.10";
  name = "shntool-${version}";

  src = fetchurl {
    url = http://www.etree.org/shnutils/shntool/dist/src/shntool-3.0.10.tar.gz;
    sha256 = "00i1rbjaaws3drkhiczaign3lnbhr161b7rbnjr8z83w8yn2wc3l";
  };

  buildInputs = [ flac ];

  meta = {
    description = "multi-purpose WAVE data processing and reporting utility";
    homepage = http://www.etree.org/shnutils/shntool/;
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; linux;
  };
}
