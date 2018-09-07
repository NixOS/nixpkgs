{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "netsurf-buildsystem-${version}";
  version = "1.7";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/buildsystem-${version}.tar.gz";
    sha256 = "1q23aaycv35ma5471l1gxib8lfq2s9kprrkaqgfc926d04rlbmhw";
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
