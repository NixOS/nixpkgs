{
  lib,
  stdenv,
  fetchurl,
  unzip,
  doxygen,
}:

stdenv.mkDerivation rec {
  pname = "bliss";
  version = "0.73";

  src = fetchurl {
    url = "http://www.tcs.hut.fi/Software/bliss/${pname}-${version}.zip";
    sha256 = "f57bf32804140cad58b1240b804e0dbd68f7e6bf67eba8e0c0fa3a62fd7f0f84";
  };

  patches = fetchurl {
    url = "http://scip.zib.de/download/bugfixes/scip-5.0.1/bliss-0.73.patch";
    sha256 = "815868d6586bcd49ff3c28e14ccb536d38b2661151088fe08187c13909c5dab0";
  };

  nativeBuildInputs = [
    unzip
    doxygen
  ];

  preBuild = ''
    doxygen Doxyfile
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/doc/bliss $out/lib $out/include/bliss
    mv bliss $out/bin
    mv html/* COPYING* $out/share/doc/bliss
    mv *.a $out/lib
    mv *.h *.hh $out/include/bliss
  '';

  meta = with lib; {
    description = "An open source tool for computing automorphism groups and canonical forms of graphs. It has both a command line user interface as well as C++ and C programming language APIs";
    mainProgram = "bliss";
    homepage = "http://www.tcs.hut.fi/Software/bliss/";
    license = licenses.lgpl3;
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
