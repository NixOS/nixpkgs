{
  lib,
  stdenv,
  fetchurl,
  nettle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rdfind";
  version = "1.8.0";

  src = fetchurl {
    url = "https://rdfind.pauldreik.se/rdfind-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-Ci0NMgAswtwBNO57ZJvMgR7PsvjZ9nKqR2qFEVLnrzU=";
  };

  buildInputs = [ nettle ];

  meta = {
    homepage = "https://rdfind.pauldreik.se/";
    description = "Removes or hardlinks duplicate files very swiftly";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = lib.platforms.all;
    mainProgram = "rdfind";
  };
})
