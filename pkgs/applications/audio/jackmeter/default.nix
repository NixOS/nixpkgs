{ stdenv, fetchurl, libjack2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "jackmeter-0.4";

  src = fetchurl {
    url = "https://www.aelius.com/njh/jackmeter/${name}.tar.gz";
    sha256 = "1cnvgx3jv0yvxlqy0l9k285zgvazmh5k8m4l7lxckjfm5bn6hm1r";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libjack2 ];

  meta = { 
    description = "Console jack loudness meter";
    homepage = https://www.aelius.com/njh/jackmeter/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
