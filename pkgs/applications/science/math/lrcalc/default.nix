{ lib, stdenv
, fetchFromBitbucket
, autoreconfHook

# Reverse dependency
, sage
}:

stdenv.mkDerivation rec {
  version = "2.1";
  pname = "lrcalc";

  src = fetchFromBitbucket {
    owner = "asbuch";
    repo = "lrcalc";
    rev = "lrcalc-${version}";
    hash = "sha256-k9zQBoGnUBMDGdI/1sAwt1xO5s7Ntq+9zBaW84eramg=";
  };

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  passthru.tests = { inherit sage; };

  meta = with lib; {
    description = "Littlewood-Richardson calculator";
    homepage = "http://math.rutgers.edu/~asbuch/lrcalc/";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    platforms = platforms.unix;
  };
}
