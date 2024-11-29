{
  mkKdeDerivation,
  qtmultimedia,
  libvlc,
}:
mkKdeDerivation {
  pname = "elisa";

  extraBuildInputs = [
    qtmultimedia
    libvlc
  ];
  meta.mainProgram = "elisa";
}
