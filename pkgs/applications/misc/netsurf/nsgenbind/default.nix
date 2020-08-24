{ stdenv, fetchurl
, flex, bison
, buildsystem
}:

stdenv.mkDerivation rec {

  pname = "netsurf-nsgenbind";
  version = "0.8";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/nsgenbind-${version}-src.tar.gz";
    sha256 = "1cqwgwca49jvmijwiyaab2bwxicgxdrnlpinf8kp3nha02nm73ad";
  };

  buildInputs = [ buildsystem flex bison ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "Generator for JavaScript bindings for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
