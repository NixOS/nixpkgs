{pkgconfig, readline, libxml2,
openmodelica, mkOpenModelicaDerivation}:

mkOpenModelicaDerivation rec {
  pname = "omsimulator";
  omdir = "OMSimulator";
  omdeps = [openmodelica.omcompiler];

  nativeBuildInputs = [pkgconfig];

  buildInputs = [readline libxml2];
}
