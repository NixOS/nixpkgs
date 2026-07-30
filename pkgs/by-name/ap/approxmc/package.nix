{
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  gmp,
  cryptominisat,
  boost,
  arjun-cnf,
  louvain-community,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "approxmc";
  version = "4.1.24";

  src = fetchFromGitHub {
    owner = "meelgroup";
    repo = "approxmc";
    rev = finalAttrs.version;
    hash = "sha256-rADPC7SVwzjUN5jb7Wt341oGfr6+LszIaBUe8QgmpRU=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    zlib
    gmp
    cryptominisat
    boost
    arjun-cnf
    louvain-community
  ];

  meta = {
    description = "Approximate Model Counter";
    homepage = "https://github.com/meelgroup/approxmc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = lib.platforms.linux;
    mainProgram = "approxmc";
  };
})
