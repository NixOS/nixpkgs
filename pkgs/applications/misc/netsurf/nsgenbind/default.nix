{ stdenv, fetchurl
, flex, bison
, buildsystem
}:

stdenv.mkDerivation rec {

  pname = "netsurf-nsgenbind";
  version = "0.7";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/nsgenbind-${version}-src.tar.gz";
    sha256 = "0rplmky4afsjwiwh7grkmcdmzg86zksa55j93dvq92f91yljwqqq";
  };

  buildInputs = [ buildsystem flex bison ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.netsurf-browser.org/;
    description = "Generator for JavaScript bindings for netsurf browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
