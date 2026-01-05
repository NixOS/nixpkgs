{
  stdenv,
  lib,
  fetchurl,
  cmake,
  buildPackages,
  pkg-config,
  python3,
  rinutils,
}:

stdenv.mkDerivation rec {
  pname = "black-hole-solver";
  version = "1.14.0";

  src = fetchurl {
    url = "https://fc-solve.shlomifish.org/downloads/fc-solve/${pname}-${version}.tar.xz";
    sha256 = "sha256-XEe9CT27Fg9LCQ/WcKt8ErQ3HTmxezu9jGxKEpdVV8A=";
  };

  nativeBuildInputs = [
    cmake
    (buildPackages.perl.withPackages (ps: [ ps.PathTiny ]))
    pkg-config
    python3
  ];
  buildInputs = [
    rinutils
  ];

  prePatch = ''
    patchShebangs ./scripts
  '';

  meta = {
    description = "Solver for Solitaire variants Golf, Black Hole, and All in a Row";
    mainProgram = "black-hole-solve";
    homepage = "https://www.shlomifish.org/open-source/projects/black-hole-solitaire-solver/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
