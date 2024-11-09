{ lib, stdenv, fetchurl, elfutils }:

stdenv.mkDerivation rec {
  pname = "dwz";
  version = "0.14";

  src = fetchurl {
    url = "https://www.sourceware.org/ftp/${pname}/releases/${pname}-${version}.tar.gz";
    sha256 = "07qdvzfk4mvbqj5z3aff7vc195dxqn1mi27w2dzs1w2zhymnw01k";
  };

  nativeBuildInputs = [ elfutils ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://sourceware.org/dwz/";
    description = "DWARF optimization and duplicate removal tool";
    mainProgram = "dwz";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jbcrail ];
    platforms = platforms.linux;
  };
}
