{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  cereal,
  immer,
  zug,
  catch2,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lager";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = "lager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xJxLLvOQxti0s1Lr1EWqYiuJLoHkSOUHiz5COnE5aog=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    cereal
    immer
    zug
  ];

  checkInputs = [
    catch2
    qt5.qtdeclarative
  ];

  cmakeFlags = [
    (lib.cmakeBool "lager_BUILD_DEBUGGER_EXAMPLES" false)
    (lib.cmakeBool "lager_BUILD_DOCS" false)
    (lib.cmakeBool "lager_BUILD_EXAMPLES" false)
    (lib.cmakeBool "lager_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  # remove BUILD file to avoid conflicts with the build directory
  preConfigure = ''
    rm BUILD
  '';

  doCheck = true;

  dontWrapQtApps = true;

  meta = {
    changelog = "https://github.com/arximboldi/lager/releases/tag/${finalAttrs.src.tag}";
    description = "C++ library for value-oriented design using the unidirectional data-flow architecture — Redux for C++";
    homepage = "https://sinusoid.es/lager/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
