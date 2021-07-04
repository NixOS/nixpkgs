{ pkg-config
, jre8
, libuuid
, openmodelica
, mkOpenModelicaDerivation
}:

mkOpenModelicaDerivation rec {
  pname = "omparser";
  omdir = "OMParser";
  omdeps = [ openmodelica.omcompiler ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ jre8 libuuid ];

  patches = [ ./Makefile.in.patch ];
}
