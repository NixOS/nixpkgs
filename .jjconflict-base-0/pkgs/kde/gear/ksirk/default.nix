{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "ksirk";

  extraBuildInputs = [ qtmultimedia ];
}
