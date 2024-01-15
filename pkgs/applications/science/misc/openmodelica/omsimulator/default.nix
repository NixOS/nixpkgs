{ lib
, pkg-config
, boost
, readline
, libxml2
, openmodelica
, mkOpenModelicaDerivation
}:

mkOpenModelicaDerivation rec {
  pname = "omsimulator";
  omdir = "OMSimulator";
  omdeps = [ openmodelica.omcompiler ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ readline libxml2 boost ];

  meta = with lib; {
    description = "The OpenModelica FMI & SSP-based co-simulation environment";
    homepage = "https://openmodelica.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ balodja smironov ];
    platforms = platforms.linux;
  };
}
