{
  lib,
  stdenv,
  fetchurl,
  nettle,
}:

stdenv.mkDerivation rec {
  pname = "rdfind";
  version = "1.7.0";

  src = fetchurl {
    url = "https://rdfind.pauldreik.se/${pname}-${version}.tar.gz";
    sha256 = "sha256-eMRjFS4dnk/Rv+uDuckt9ef8TF+Tx9Qm+x9++ivk3yk=";
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
}
