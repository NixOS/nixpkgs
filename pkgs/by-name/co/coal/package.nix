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
  pkg-config,
  qhull,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coal";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "coal-library";
    repo = "coal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2fmu2VZJ+Fd87q2RpnJU61v6Lj2C9r5iweFrr1HwQQI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  propagatedBuildInputs = [
    assimp
    jrl-cmakemodules
    octomap
    qhull
    zlib
    boost
    eigen
  ];

  cmakeFlags = [
    (lib.cmakeBool "COAL_BACKWARD_COMPATIBILITY_WITH_HPP_FCL" true)
    (lib.cmakeBool "COAL_HAS_QHULL" true)
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
  ];

  doCheck = true;

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
