{
  mkKdeDerivation,
  qtdeclarative,
  bison,
  flex,
  boost,
  python3,
}:
mkKdeDerivation {
  pname = "kopeninghours";

  extraNativeBuildInputs = [
    bison
    flex
  ];
  extraBuildInputs = [
    qtdeclarative
    (boost.override {
      enablePython = true;
      python = python3;
    })
    python3
  ];
}
