{
  lib,
  stdenv,
  fetchFromBitbucket,
  autoreconfHook,

  # Reverse dependency
  sage,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.1";
  pname = "lrcalc";

  src = fetchFromBitbucket {
    owner = "asbuch";
    repo = "lrcalc";
    rev = "lrcalc-${finalAttrs.version}";
    hash = "sha256-k9zQBoGnUBMDGdI/1sAwt1xO5s7Ntq+9zBaW84eramg=";
  };

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  passthru.tests = { inherit sage; };

  meta = {
    description = "Littlewood-Richardson calculator";
    homepage = "http://math.rutgers.edu/~asbuch/lrcalc/";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.unix;
  };
})
