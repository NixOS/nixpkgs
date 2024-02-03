{ stdenv
, fetchFromGitHub
, cmake
, zlib
, gmp
, cryptominisat
, boost
, arjun-cnf
, louvain-community
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "approxmc";
  version = "4.1.23";

  src = fetchFromGitHub {
    owner = "meelgroup";
    repo = "approxmc";
    rev = finalAttrs.version;
    hash = "sha256-pE2m6Cc2u53H/5CM+2JuQxZOhjhHUZOi0kn23CJmALM=";
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

  meta = with lib; {
    description = "Approximate Model Counter";
    homepage = "https://github.com/meelgroup/approxmc";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
    platforms = platforms.linux;
    mainProgram = "approxmc";
  };
})
