{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "lp_solve-${version}";
  version = "5.5.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/lpsolve/lpsolve/${version}/lp_solve_${version}_source.tar.gz";
    sha256 = "176c7f023mb6b8bfmv4rfqnrlw88lsg422ca74zjh19i2h5s69sq";
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
    cp -v bin/*/* $out/lib
    )
    (
    cd lp_solve*/lp_solve
    bash ccc
    mkdir -pv $out/bin
    cp -v bin/*/* $out/bin
    )
    (
    mkdir -pv $out/include
    cp -v lp_solve*/*.h $out/include
    )
  '';

  meta = with stdenv.lib; {
    description = "A Mixed Integer Linear Programming (MILP) solver";
    homepage    = "http://lpsolve.sourceforge.net";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ smironov ];
    platforms   = platforms.unix;
  };

}

