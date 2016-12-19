{ stdenv, fetchurl
, flex, bison
, buildsystem
}:

stdenv.mkDerivation rec {

  name = "netsurf-nsgenbind-${version}";
  version = "0.3";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/nsgenbind-${version}-src.tar.gz";
    sha256 = "16xsazly7gxwywmlkf2xix9b924sj3skhgdak7218l0nc62a08gg";
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
