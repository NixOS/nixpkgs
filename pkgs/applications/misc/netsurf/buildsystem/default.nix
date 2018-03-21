{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "netsurf-buildsystem-${version}";
  version = "1.6";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/buildsystem-${version}.tar.gz";
    sha256 = "0p5k708lcq8dip9xxck6hml32bjrbyipprm22bbsvdnsc0pqm71x";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.netsurf-browser.org/;
    description = "Build system for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
