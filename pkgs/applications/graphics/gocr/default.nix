{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gocr-0.44";

  src = fetchurl {
    url = http://prdownloads.sourceforge.net/jocr/gocr-0.44.tar.gz;
    sha256 = "0kvb7cbk6z5n4g0hhbwpdk2f3819yfamwsmkwanj99yhni6p5mr0";
  };

  meta = {
    description = "GPL Optical Character Recognition";
  };
}
