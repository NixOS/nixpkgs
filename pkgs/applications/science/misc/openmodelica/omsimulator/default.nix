{
  lib,
  pkg-config,
  boost,
  readline,
  libxml2,
  openmodelica,
  mkOpenModelicaDerivation,
  fetchpatch,
}:

mkOpenModelicaDerivation {
  pname = "omsimulator";
  omdir = "OMSimulator";
  omdeps = [ openmodelica.omcompiler ];

  patches = [
    (fetchpatch {
      url = "https://github.com/OpenModelica/OMSimulator/commit/5ef06e251d639a0224adc205cdbfa1f99bf9a956.patch";
      stripLen = 1;
      extraPrefix = "OMSimulator/";
      hash = "sha256-hLsS6TNEjddm2o2Optnf8n6hh14up9bWJBoztNmisH0=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    readline
    libxml2
    boost
  ];

  env.CFLAGS = toString [
    "-Wno-error=implicit-function-declaration"
  ];

  meta = with lib; {
    description = "OpenModelica FMI & SSP-based co-simulation environment";
    homepage = "https://openmodelica.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      balodja
      smironov
    ];
    platforms = platforms.linux;
  };
}
