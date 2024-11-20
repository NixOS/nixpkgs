{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  boost,
  eigen,
  assimp,
  octomap,
  qhull,
  pythonSupport ? false,
  python3Packages,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-fcl";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-fcl";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-co0x3amUok2Uhww0+DrK+PkwjAnIpEtMIIpv0ZDRzYo=";
  };

  strictDeps = true;

  nativeBuildInputs =
    [
      cmake
      doxygen
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.numpy
      python3Packages.pythonImportsCheckHook
    ];

  propagatedBuildInputs =
    [
      assimp
      qhull
      octomap
      zlib
    ]
    ++ lib.optionals (!pythonSupport) [
      boost
      eigen
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.boost
      python3Packages.eigenpy
    ];

  cmakeFlags = [
    (lib.cmakeBool "HPP_FCL_HAS_QHULL" true)
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;
  pythonImportsCheck = [ "hppfcl" ];

  outputs = [
    "dev"
    "out"
    "doc"
  ];
  postFixup = ''
    moveToOutput share/ament_index "$dev"
    moveToOutput share/${finalAttrs.pname} "$dev"
  '';

  meta = {
    description = "Extension of the Flexible Collision Library";
    homepage = "https://github.com/humanoid-path-planner/hpp-fcl";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
