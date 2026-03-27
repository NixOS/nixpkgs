{
  lib,
  stdenv,
  fetchurl,
  lzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lziprecover";
  version = "1.26";

  src = fetchurl {
    url = "mirror://savannah/lzip/lziprecover/lziprecover-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-4jQAWnVtVkn0FoYRbT5UhzbUp35aXsN7lDymZQeHgB0=";
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
    ];
    platforms = lib.platforms.all;
    mainProgram = "lziprecover";
  };
})
