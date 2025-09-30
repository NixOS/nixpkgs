{
  lib,
  stdenv,
  fetchurl,
  bison,
  flex,
  netsurf-buildsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nsgenbind";
  version = "0.8";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/nsgenbind-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-TY1TrQAK2nEncjZeanPrj8XOl1hK+chlrFsmohh/HLM=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  buildInputs = [ netsurf-buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${netsurf-buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "Generator for JavaScript bindings for netsurf browser";
    mainProgram = "nsgenbind";
    license = lib.licenses.mit;
    inherit (netsurf-buildsystem.meta) maintainers platforms;
  };
})
