{ stdenv, fetchurl, cmake, gfortran, openblas, openmpi, petsc, python3 }:

stdenv.mkDerivation rec {
  name = "getdp-${version}";
  version = "3.3.0";
  src = fetchurl {
    url = "http://getdp.info/src/getdp-${version}-source.tgz";
    sha256 = "1pfviy2bw8z5y6c15czvlvyjjg9pvpgrj9fr54xfi2gmvs7zkgpf";
  };

  nativeBuildInputs = [ cmake gfortran ];
  buildInputs = [ openblas openmpi petsc python3 ];

  meta = with stdenv.lib; {
    description = "A General Environment for the Treatment of Discrete Problems";
    longDescription = ''
      GetDP is a free finite element solver using mixed elements to discretize
      de Rham-type complexes in one, two and three dimensions.  The main
      feature of GetDP is the closeness between the input data defining
      discrete problems (written by the user in ASCII data files) and the
      symbolic mathematical expressions of these problems.
    '';
    homepage = "http://getdp.info/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.linux;
  };
}
