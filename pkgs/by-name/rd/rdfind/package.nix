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

  meta = with lib; {
    homepage = "https://rdfind.pauldreik.se/";
    description = "Removes or hardlinks duplicate files very swiftly";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.wmertens ];
    platforms = platforms.all;
    mainProgram = "rdfind";
  };
}
