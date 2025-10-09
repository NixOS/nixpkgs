{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  boost,
  eigen,
  jrl-cmakemodules,
  assimp,
  octomap,
  qhull,
  pythonSupport ? false,
  python3Packages,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coal";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "coal-library";
    repo = "coal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7Ww1vAzKaCccBpBQU1hzI7Jk+oXw73zhnH594Xn9gbw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.numpy
    python3Packages.pythonImportsCheckHook
  ];

  propagatedBuildInputs = [
    assimp
    jrl-cmakemodules
    octomap
    qhull
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
    (lib.cmakeBool "COAL_BACKWARD_COMPATIBILITY_WITH_HPP_FCL" true)
    (lib.cmakeBool "COAL_HAS_QHULL" true)
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;
  pythonImportsCheck = [
    "coal"
    "hppfcl"
  ];

  outputs = [
    "dev"
    "out"
    "doc"
  ];
  postFixup = ''
    moveToOutput share/ament_index "$dev"
    moveToOutput share/coal "$dev"
  '';

  meta = {
    description = "Collision Detection Library, previously hpp-fcl";
    homepage = "https://github.com/coal-library/coal";
    changelog = "https://github.com/coal-library/coal/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
