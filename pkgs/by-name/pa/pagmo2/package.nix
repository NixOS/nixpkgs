{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  nlopt,
  ipopt,
  boost,
  onetbb,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pagmo2";
  version = "2.19.1";

  src = fetchFromGitHub {
    owner = "esa";
    repo = "pagmo2";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ido3e0hQLDEPT0AmsfAVTPlGbWe5QBkxgRO6Fg1wp/c=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    onetbb
  ];

  propagatedBuildInputs = [
    eigen
    nlopt
    ipopt
    boost
  ];

  cmakeFlags = [
    (lib.cmakeBool "PAGMO_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "PAGMO_WITH_EIGEN3" true)
    (lib.cmakeBool "PAGMO_WITH_NLOPT" true)
    (lib.cmakeBool "PAGMO_WITH_IPOPT" true)
  ];

  env = {
    # Workaround clang17+ / lto bug
    # See https://github.com/esa/pagmo2/pull/585
    # Should be removed in new release
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-fno-assume-unique-vtables";
  };

  doCheck = true;

  passthru = {
    tests.cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "pagmo" ];
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://esa.github.io/pagmo2/";
    description = "Scientific library for massively parallel optimization";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.costrouc ];
  };
})
