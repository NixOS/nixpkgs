{
  lib,
  stdenv,
  fetchurl,
  lzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lziprecover";
  version = "1.25";

  src = fetchurl {
    url = "mirror://savannah/lzip/lziprecover/lziprecover-${finalAttrs.version}.tar.gz";
    sha256 = "4f392f9c780ae266ee3d0db166b0f1b4d3ae07076e401dc2b199dc3a0fff8b45";
    # This hash taken from the mailing list announcement.
  };

  configureFlags = [
    "CPPFLAGS=-DNDEBUG"
    "CFLAGS=-O3"
    "CXXFLAGS=-O3"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  doCheck = true;
  nativeCheckInputs = [ lzip ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.nongnu.org/lzip/lziprecover.html";
    description = "Data recovery tool for lzip compressed files";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      vlaci
      ehmry
    ];
    platforms = lib.platforms.all;
    mainProgram = "lziprecover";
  };
})
