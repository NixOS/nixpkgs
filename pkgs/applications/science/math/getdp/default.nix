{ stdenv, fetchurl, cmake, gfortran, openblas, openmpi, python3 }:

stdenv.mkDerivation rec {
  name = "getdp-${version}";
  version = "3.0.4";
  src = fetchurl {
    url = "http://getdp.info/src/getdp-${version}-source.tgz";
    sha256 = "0v3hg03lzw4hz28hm45hpv0gyydqz0wav7xvb5n0v0jrm47mrspv";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gfortran openblas openmpi python3 ];

  meta = with stdenv.lib; {
    description = "A General Environment for the Treatment of Discrete Problems";
    longDescription = ''
      GetDP is a free finite element solver using mixed elements to discretize de Rham-type complexes in one, two and three dimensions.
      The main feature of GetDP is the closeness between the input data defining discrete problems (written by the user in ASCII data files) and the symbolic mathematical expressions of these problems.
    '';
    homepage = http://getdp.info/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.linux;
  };
}
