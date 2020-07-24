{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  pname = "netsurf-buildsystem";
  version = "1.8";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/buildsystem-${version}.tar.gz";
    sha256 = "0ffdjwskxlnh8sk40qqfgksbb1nrdzfxsshrscra0p4nqpkj98z6";
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
