{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  clipper2,
  gtest,
  glm,
  tbb_2021_11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "manifold";
  version = "2.5.1-unstable-2024-11-08";

  src = fetchFromGitHub {
    owner = "elalish";
    repo = "manifold";
    rev = "66bca6e3fdfce0f590ca84edc1a6256502636f4b";
    hash = "sha256-XgmJtkBf5SOgvtwU2x1cJLjEQKEmKnB40oIaoYrUYEQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    gtest
    glm
    tbb_2021_11
    clipper2
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DMANIFOLD_TEST=ON"
    "-DMANIFOLD_CROSS_SECTION=ON"
    "-DMANIFOLD_PAR=TBB"
  ];

  doCheck = true;
  checkPhase = ''
    test/manifold_test
  '';

  meta = {
    description = "Geometry library for topological robustness";
    homepage = "https://github.com/elalish/manifold";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      hzeller
      pca006132
    ];
    platforms = lib.platforms.linux; # currently issues with Darwin
  };
})
