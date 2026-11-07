{
  mkKdeDerivation,
  qtwayland,
  pkg-config,
  libxscrnsaver,
}:
mkKdeDerivation {
  pname = "kidletime";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtwayland
    libxscrnsaver
  ];
}
