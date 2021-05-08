{pkgconfig, jre, libuuid,
openmodelica, mkOpenModelicaDerivation }:

mkOpenModelicaDerivation rec {
  pname = "omparser";
  omdir = "OMParser";
  omdeps = [openmodelica.omcompiler];

  nativeBuildInputs = [pkgconfig];

  buildInputs = [jre libuuid];

  patchPhase = ''
    patch -p1 < ${./Makefile.in.patch}
  '';
}
