{
  mkKdeDerivation,
  qtsvg,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "kwordquiz";

  extraBuildInputs = [
    qtsvg
    qtmultimedia
  ];
  meta.mainProgram = "kwordquiz";
}
