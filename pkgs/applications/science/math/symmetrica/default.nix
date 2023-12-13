{ stdenv
, lib
, fetchFromGitLab
, autoreconfHook
}:
stdenv.mkDerivation rec {
  pname = "symmetrica";
  version = "3.0.1";

  # Fork of the original symmetrica, which can be found here
  # http://www.algorithm.uni-bayreuth.de/en/research/SYMMETRICA/index.html
  # "This fork was created to modernize the codebase, and to resume making
  # releases with the fixes that have accrued over the years."
  # Also see https://trac.sagemath.org/ticket/29061#comment:3.
  src = fetchFromGitLab {
    owner = "sagemath";
    repo = "symmetrica";
    rev = version;
    sha256 = "0wfmrzw82f5i91d7rf24mcdqcj2fmgrgy02pw4pliz7ncwaq14w3";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A collection of routines for representation theory and combinatorics";
    license = licenses.isc;
    maintainers = teams.sage.members;
    platforms = platforms.unix;
    homepage = "https://gitlab.com/sagemath/symmetrica";
  };
}
