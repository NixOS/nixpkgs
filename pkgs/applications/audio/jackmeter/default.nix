{ stdenv, fetchurl, jack2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "jackmeter-0.4";

  src = fetchurl {
    url = "http://www.aelius.com/njh/jackmeter/${name}.tar.gz";
    sha256 = "1cnvgx3jv0yvxlqy0l9k285zgvazmh5k8m4l7lxckjfm5bn6hm1r";
  };

  buildInputs = [ jack2 pkgconfig ];

  meta = { 
    description = "Console jack loudness meter";
    homepage = http://www.aelius.com/njh/jackmeter/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
