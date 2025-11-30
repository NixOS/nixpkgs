{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  cryptominisat,
  boost,
  louvain-community,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "arjun-cnf";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "meelgroup";
    repo = "arjun";
    rev = finalAttrs.version;
    hash = "sha256-5duc05s654HLjbf+dPgyMn6QUVvB0vLji3M4S2o/QYU=";
  };

  # Can be removed after next release
  patches = [
    (fetchpatch {
      url = "https://github.com/meelgroup/arjun/commit/34188760f1ab4b1b557c45ccaee8d2b9b6f0b901.patch";
      hash = "sha256-E/yk2ohHP2BAFg353r8EU01bZCqeEjvpJCrBsxPiOWM=";
    })
    # Based on https://github.com/meelgroup/arjun/commit/99c4ed4ad820674632c5d9bbcc98c001f8cac98f
    ./fix-red-clause.patch
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    cryptominisat
    louvain-community
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.3 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    description = "CNF minimizer and minimal independent set calculator";
    homepage = "https://github.com/meelgroup/arjun";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
    platforms = platforms.linux;
    mainProgram = "arjun";
  };
})
