{
  libint,
}:

libint.override {
  enableFortran = false;
  enableSSE = false;
  maxAm = 6;
  eriDeriv = 2;
  eri3Deriv = 2;
  eri2Deriv = 2;
  eriAm = [
    6
    5
    4
  ];
  eri3Am = [
    6
    5
    4
  ];
  eri2Am = [
    6
    5
    4
  ];
  eriOptAm = [
    3
    2
    2
  ];
  eri3OptAm = [
    3
    2
    2
  ];
  eri2OptAm = [
    3
    2
    2
  ];
  enableOneBody = true;
  oneBodyDerivOrd = 2;
  enableGeneric = false;
  enableContracted = false;
  cartGaussOrd = "standard";
  shGaussOrd = "gaussian";
  eri2PureSh = false;
  eri3PureSh = false;
}
