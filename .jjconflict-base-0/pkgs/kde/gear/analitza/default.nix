{
  mkKdeDerivation,
  qt5compat,
  qtsvg,
  qttools,
  qtdeclarative,
  eigen,
}:
mkKdeDerivation {
  pname = "analitza";

  extraNativeBuildInputs = [
    qt5compat
    qtsvg
    qttools
  ];
  extraBuildInputs = [
    qtdeclarative
    eigen
  ];
}
