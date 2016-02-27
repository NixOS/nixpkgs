{ stdenv, fetchurl, libjpeg }:

stdenv.mkDerivation rec {
  version = "1.0.6";
  name = "jp2a-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/jp2a/${name}.tar.gz";
    sha256 = "076frk3pa16s4r1b10zgy81vdlz0385zh3ykbnkaij25jn5aqc09";
  };

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ libjpeg ];

  meta = with stdenv.lib; {
    homepage = https://csl.name/jp2a/;
    description = "A small utility that converts JPG images to ASCII";
    license = licenses.gpl2;
  };
}
