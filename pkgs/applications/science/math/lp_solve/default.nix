{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {

  pname = "lp_solve";
  version = "5.5.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/project/lpsolve/lpsolve/${version}/lp_solve_${version}_source.tar.gz";
    sha256 = "12pj1idjz31r7c2mb5w03vy1cmvycvbkx9z29s40qdmkp1i7q6i0";
  };

  patches = [ ./isnan.patch ];

  buildCommand = ''
    . $stdenv/setup
    tar xvfz $src
    (
    cd lp_solve*
    eval patchPhase
    )
    (
    cd lp_solve*/lpsolve55
    bash ccc
    mkdir -pv $out/lib
    find bin -type f -exec cp -v "{}" $out/lib \;
    )
    (
    cd lp_solve*/lp_solve
    bash ccc
    mkdir -pv $out/bin
    find bin -type f -exec cp -v "{}" $out/bin \;
    )
    (
    mkdir -pv $out/include
    cp -v lp_solve*/*.h $out/include
    )
  '';

  meta = with lib; {
    description = "A Mixed Integer Linear Programming (MILP) solver";
    homepage    = "http://lpsolve.sourceforge.net";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ smironov ];
    platforms   = platforms.unix;
  };

}

