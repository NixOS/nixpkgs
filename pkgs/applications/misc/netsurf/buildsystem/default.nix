{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  pname = "netsurf-buildsystem";
  version = "1.9";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/buildsystem-${version}.tar.gz";
    sha256 = "0alsmaig9ln8dgllb3z63gq90fiz75jz0ic71fi0k0k898qix14k";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "Build system for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.unix;
  };
}
