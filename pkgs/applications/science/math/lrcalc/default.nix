{ stdenv
, fetchFromBitbucket
, fetchpatch
, autoreconfHook
}:

stdenv.mkDerivation rec {
  version = "1.2";
  pname = "lrcalc";

  src = fetchFromBitbucket {
    owner = "asbuch";
    repo = "lrcalc";
    rev = "lrcalc-${version}";
    sha256 = "1c12d04jdyxkkav4ak8d1aqrv594gzihwhpxvc6p9js0ry1fahss";
  };

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  patches = [
    # Fix include syntax:
    # For private includes, use `#include "..."` instead of `#include <...>`
    (fetchpatch {
      url = "https://bitbucket.org/asbuch/lrcalc/commits/226981a0/raw/";
      sha256 = "02kaqx5s3l642rhh28kn2wg9wr098vzpknxyl4pv627lqa3lv9vm";
    })
  ];

  meta = with stdenv.lib; {
    description = "Littlewood-Richardson calculator";
    homepage = http://math.rutgers.edu/~asbuch/lrcalc/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.unix;
  };
}
