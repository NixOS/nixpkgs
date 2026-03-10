{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  clipper2,
  gtest,
  onetbb,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "manifold";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "elalish";
    repo = "manifold";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9h1MLEcqLpiFg8U5rRkR9Qa+ohzehEDCn5rNsN6swlQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    gtest
    onetbb
  ];

  propagatedBuildInputs = [ clipper2 ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DMANIFOLD_TEST=ON"
    "-DMANIFOLD_CROSS_SECTION=ON"
    "-DMANIFOLD_PAR=TBB"
  ];

  excludedTestPatterns = [
  ];
  doCheck = true;
  checkPhase = ''
    test/manifold_test --gtest_filter=-${lib.escapeShellArg (builtins.concatStringsSep ":" finalAttrs.excludedTestPatterns)}
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
