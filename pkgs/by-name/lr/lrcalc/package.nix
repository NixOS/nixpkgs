{
  lib,
  stdenv,
  fetchFromBitbucket,
  autoreconfHook,

  # Reverse dependency
  sage,
}:

stdenv.mkDerivation rec {
  version = "2.1";
  pname = "lrcalc";

  src = fetchFromBitbucket {
    owner = "asbuch";
    repo = "lrcalc";
    rev = "lrcalc-${version}";
    sha256 = "0s3amf3z75hnrjyszdndrvk4wp5p630dcgyj341i6l57h43d1p4k";
  };

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  passthru.tests = { inherit sage; };

<<<<<<< HEAD
  meta = {
    description = "Littlewood-Richardson calculator";
    homepage = "http://math.rutgers.edu/~asbuch/lrcalc/";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Littlewood-Richardson calculator";
    homepage = "http://math.rutgers.edu/~asbuch/lrcalc/";
    license = licenses.gpl2Plus;
    teams = [ teams.sage ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
