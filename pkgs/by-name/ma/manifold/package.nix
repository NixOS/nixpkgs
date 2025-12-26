{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  clipper2,
  gtest,
  glm,
  onetbb,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "manifold";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "elalish";
    repo = "manifold";
    tag = "v${finalAttrs.version}";
    hash = "sha256-583/phb0boc5ASFJN+DDn6bogeNPVYPBTgtcD/d/AS8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    gtest
    glm
    onetbb
  ];

  propagatedBuildInputs = [ clipper2 ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DMANIFOLD_TEST=ON"
    "-DMANIFOLD_CROSS_SECTION=ON"
    "-DMANIFOLD_PAR=TBB"
  ];

  excludedTestPatterns = lib.optionals stdenv.isDarwin [
    # https://github.com/elalish/manifold/issues/1306
    "Manifold.Simplify"
  ];
  doCheck = true;
  checkPhase = ''
    test/manifold_test --gtest_filter=-${builtins.concatStringsSep ":" finalAttrs.excludedTestPatterns}
  '';

  passthru = {
    tests = {
      python = python3Packages.manifold3d;
    };
  };

  meta = {
    description = "Geometry library for topological robustness";
    homepage = "https://github.com/elalish/manifold";
    changelog = "https://github.com/elalish/manifold/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers =
      with lib.maintainers;
      [
        hzeller
        pca006132
      ]
      ++ python3Packages.manifold3d.meta.maintainers;
    platforms = lib.platforms.unix;
  };
})
