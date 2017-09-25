{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "netsurf-buildsystem-${version}";
  version = "1.5";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/buildsystem-${version}.tar.gz";
    sha256 = "0wdgvasrjik1dgvvpqbppbpyfzkqd1v45x3g9rq7p67n773azinv";
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
