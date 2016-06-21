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
    description = "Multi-purpose WAVE data processing and reporting utility";
    homepage = http://www.etree.org/shnutils/shntool/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
