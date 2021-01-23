{ lib, stdenv, fetchurl
, flex, bison
, buildsystem
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "nsgenbind";
  version = "0.8";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-TY1TrQAK2nEncjZeanPrj8XOl1hK+chlrFsmohh/HLM=";
  };

  buildInputs = [ flex bison buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/";
    description = "Generator for JavaScript bindings for netsurf browser";
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
