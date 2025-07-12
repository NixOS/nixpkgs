{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  clipper2,
  gtest,
  glm,
  tbb_2021,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "manifold";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "elalish";
    repo = "manifold";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dCCTjWRjXSyuEDxGI9ZS2UTmLdZVSmDOmHFnhox3N+4=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    gtest
    glm
    tbb_2021
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
    test/manifold_test --gtest_filter=-CrossSection.RoundOffset
  '';

  meta = {
    description = "Geometry library for topological robustness";
    homepage = "https://github.com/elalish/manifold";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      hzeller
      pca006132
    ];
    platforms = lib.platforms.unix;
  };
})
